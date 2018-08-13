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

protocol SlashCommandsControllerDelegate: class {

    func received(command: SlashCommand)

}

final class SlashCommandsController: RouteCollection {

    weak var delegate: SlashCommandsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("slashcommands")
        route.post("", use: postHandler)
    }

    func postHandler(_ req: Request) throws -> HTTPStatus {
        let command = try req.content.syncDecode(SlashCommand.self)
        delegate?.received(command: command)
        return .ok
    }

}
