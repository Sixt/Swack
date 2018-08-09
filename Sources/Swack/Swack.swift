//
//  Swack.swift
//  App
//
//  Created by franz busch on 14.05.18.
//

import Vapor
import Foundation

public typealias EventListener = (EventsAPIRequest) -> ()

private struct MessageListener {

    let regex: String
    let callback: ((MessageEvent, Swack) -> Void)

    func matches(input: String) throws -> Bool {
        let expression = try NSRegularExpression(pattern: regex, options: [])
        let match = expression.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count))

        return match != nil
    }

}

private struct SlashCommandListener {

    let command: String
    let callback: ((SlashCommand, Swack) -> Void)

}

public class Swack {

    private let application: Application
    private let client: Client

    private let chatService: ChatService
    private let dialogService: DialogService

    private var messageListeners = [MessageListener]()
    private var slashCommandListeners = [SlashCommandListener]()

    private var dialogs = [String: Dialog]()

    public init(_ env: Environment, token: String) throws {
        let config = Config.default()
        var services = Services.default()
        let router = EngineRouter.default()
        services.register(router, as: Router.self)
        var middlewares = MiddlewareConfig()
        middlewares.use(ErrorMiddleware.self)
        services.register(middlewares)
        let app = try Application(config: config, environment: env, services: services)

        self.application = app
        self.client = try application.client()
        self.chatService = ChatService(client: client, token: token)
        self.dialogService = DialogService(client: client, token: token)

        try setupRoutes()

        let _ = app.asyncRun()
    }

    private func setupRoutes() throws {
        let router = try application.make(Router.self)

        let eventsController = EventsController()
        eventsController.delegate = self
        try eventsController.boot(router: router)

        let slashCommandsController = SlashCommandsController()
        slashCommandsController.delegate = self
        try slashCommandsController.boot(router: router)

        let interactiveComponentsController = InteractiveComponentsController()
        interactiveComponentsController.delegate = self
        try interactiveComponentsController.boot(router: router)
    }


    public func addMessageListener(for regex: String, callback: @escaping (MessageEvent, Swack) -> Void) {
        messageListeners.append(MessageListener(regex: regex, callback: callback))
    }

    public func addSlashCommandListener(for command: String, callback: @escaping (SlashCommand, Swack) -> Void) {
        slashCommandListeners.append(SlashCommandListener(command: command, callback: callback))
    }

    @discardableResult
    public func replyWithDialog(to slashCommand: SlashCommand, dialog: Dialog) -> Future<Response> {
        let dialogOpenRequest = DialogOpenRequest(triggerId: slashCommand.triggerId, dialog: dialog)
        dialogs[dialog.callbackId] = dialog
        return dialogService.post(dialogOpenRequest)
    }

}


// MARK: WebAPI - Chat
extension Swack {

    @discardableResult
    public func reply(to replyable: Replyable, text: String) -> Future<Response> {
        return post(to: replyable.toChannel, text: text)
    }

    @discardableResult
    public func replyEphemeral(to replyable: Replyable, text: String) -> Future<Response> {
        let message = ChatPostEphemeralMessage(channel: replyable.toChannel, user: replyable.toUser, text: text)
        return chatService.postEphemeral(message)
    }

    @discardableResult
    public func post(to channel: String, text: String) -> Future<Response> {
        let message = ChatPostMessage(channel: channel, text: text)
        return chatService.post(message)
    }

}

extension Swack: EventsControllerDelegate {

    func received(event: EventsAPIRequest) {
        guard let type = event.event?.type else {
            return
        }

        switch type {
        case .message:
            let messageEvent = event.event as! MessageEvent
            messageListeners.filter { (try? $0.matches(input: messageEvent.text)) ?? false }
                .forEach { $0.callback(messageEvent, self) }
        }
    }

}

extension Swack: SlashCommandsControllerDelegate {


    func received(command: SlashCommand) {
        slashCommandListeners.filter { $0.command == command.command }.forEach { $0.callback(command, self) }
    }

}

extension Swack: InteractiveComponentsControllerDelegate {

    func received(submission: DialogSubmission) {
        dialogs[submission.callbackId]?.onSubmission(submission)
    }

}
