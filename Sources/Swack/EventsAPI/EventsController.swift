//
//  EventsController.swift
//  App
//
//  Created by franz busch on 14.05.18.
//

import Vapor

protocol EventsControllerDelegate: class {

    func received(event: EventsAPIRequest)

}

final class EventsController: RouteCollection {

    weak var delegate: EventsControllerDelegate?

    func boot(router: Router) throws {
        let route = router.grouped("events")

        route.post(EventsAPIRequest.self, at:"", use: postHandler)
    }

    func postHandler(_ req: Request, eventRequest: EventsAPIRequest) throws -> EventsAPIResponse {
        delegate?.received(event: eventRequest)
        return EventsAPIResponse(challenge: eventRequest.challenge)
    }

}
