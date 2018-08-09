//
//  SlashCommandsController.swift
//  App
//
//  Created by franz busch on 04.07.18.
//

import Vapor

protocol SlashCommandsControllerDelegate: class {

    func received(command: SlashCommand)

}

final class SlashCommandsController: RouteCollection {

    weak var delegate: SlashCommandsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("slashcommands")
        route.post(SlashCommand.self, at:"", use: postHandler)
    }

    func postHandler(_ req: Request, command: SlashCommand) throws -> HTTPStatus {
        delegate?.received(command: command)
        return .ok
    }

}
