//===----------------------------------------------------------------------===//
//
// This source file is part of the Swack open source project
//
// Copyright (c) 2018 e-Sixt
// Licensed under MIT
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import Vapor
import Foundation

public typealias EventListener = (EventsAPIRequest) -> ()

public protocol SlashCommandListener: class {

    var command: String { get }

    func slashCommandReceived(command: SlashCommand, swack: Swack)

}

public protocol MessageListener: class {

    var regex: String { get }

    func messageReceived(_ messageEvent: MessageEvent, swack: Swack)

}

extension MessageListener {

    func matches(input: String) throws -> Bool {
        let expression = try NSRegularExpression(pattern: regex, options: [])
        let match = expression.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count))

        return match != nil
    }

}

public typealias DialogSubmissionListener = (DialogSubmission, Swack) -> Void

public class Swack {

    private let application: Application
    private let client: Client

    private let chatService: ChatService
    private let dialogService: DialogService
    private let authService: AuthService

    private var messageListeners = [MessageListener]()
    private var slashCommandListeners = [SlashCommandListener]()

    private var dialogs = [String: DialogSubmissionListener]()

    public private(set) var userId: String = ""

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
        self.authService = AuthService(client: client, token: token)

        try authService.test().map { response in
            self.userId = response.userId
        }.wait()

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


    public func addMessageListener(_ listener: MessageListener) {
        messageListeners.append(listener)
    }

    public func addSlashCommandListener(_ listener: SlashCommandListener) {
        slashCommandListeners.append(listener)
    }

    @discardableResult
    public func replyWithDialog(to slashCommand: SlashCommand, dialog: Dialog, onSubmission: @escaping DialogSubmissionListener) -> Future<Response> {
        let dialogOpenRequest = DialogOpenRequest(triggerId: slashCommand.triggerId, dialog: dialog)
        dialogs[dialog.callbackId] = onSubmission
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
        switch event.event {
        case let event as MessageEvent:
            messageEventReceived(event)
        default:
            break
        }
    }

    func messageEventReceived(_ event: MessageEvent) {
        for listener in messageListeners {
            guard (try? listener.matches(input: event.text)) ?? false else { return }
            listener.messageReceived(event, swack: self)
        }
    }

}

extension Swack: SlashCommandsControllerDelegate {


    func received(command: SlashCommand) {
        for listener in slashCommandListeners {
            guard listener.command == command.command else { return }
            listener.slashCommandReceived(command: command, swack: self)
        }
    }

}

extension Swack: InteractiveComponentsControllerDelegate {

    func received(submission: DialogSubmission) {
        dialogs[submission.callbackId]?(submission, self)
    }

}
