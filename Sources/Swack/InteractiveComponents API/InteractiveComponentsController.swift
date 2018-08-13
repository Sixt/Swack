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

protocol InteractiveComponentsControllerDelegate: class {

    func received(submission: DialogSubmission)

}

final class InteractiveComponentsController: RouteCollection {

    weak var delegate: InteractiveComponentsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("actions")
        route.post("", use: postHandler)
    }

    func postHandler(_ req: Request) throws -> HTTPStatus {
        let component = try req.content.syncDecode(InteractiveComponentAPIRequest.self)

        switch component {
        case let .dialogSubmission(submission):
            delegate?.received(submission: submission)
        default:
            break
        }

        return .ok
    }

}

