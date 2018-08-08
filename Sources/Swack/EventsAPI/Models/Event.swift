//
//  Event.swift
//  App
//
//  Created by franz busch on 13.02.18.
//

import Vapor

public enum EventType: String, Codable {
    case message
}

public protocol Event: Codable {

    var type: EventType { get set }
    var eventTimestamp: String { get set }
    var user: String { get set }

}
