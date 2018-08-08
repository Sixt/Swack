//
//  InteractiveComponentsController.swift
//  App
//
//  Created by franz busch on 15.07.18.
//

import Vapor

protocol InteractiveComponentsControllerDelegate: class {

    func received(submission: DialogSubmission)

}

final class InteractiveComponentsController: RouteCollection {

    weak var delegate: InteractiveComponentsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("actions")
        route.post(InteractiveComponentAPIRequest.self, at:"", use: postHandler)
    }

    func postHandler(_ req: Request, component: InteractiveComponentAPIRequest) throws -> HTTPStatus {
        switch component {
        case let .dialogSubmission(submission):
            delegate?.received(submission: submission)
        default:
            break
        }

        return .ok
    }

}

