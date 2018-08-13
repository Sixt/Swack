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

protocol EventsControllerDelegate: class {

    func received(event: EventsAPIRequest)

}

final class EventsController: RouteCollection {

    weak var delegate: EventsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("events")
        route.post("", use: postHandler)
    }

    func postHandler(_ req: Request) throws -> EventsAPIResponse {
        let eventRequest = try req.content.syncDecode(EventsAPIRequest.self)
        delegate?.received(event: eventRequest)
        
        return EventsAPIResponse(challenge: eventRequest.challenge)
    }

}
