//
//  MessageEvent.swift
//  App
//
//  Created by franz busch on 13.02.18.
//

import Vapor

public protocol Replyable {

    var toChannel: String { get }
    var toUser: String { get }

}

public struct MessageEvent: Event {

    public var type: EventType
    public var eventTimestamp: String
    public var user: String

    public var channel: String
    public var text: String

    enum CodingKeys: String, CodingKey {
        case type
        case channel
        case user
        case text
        case eventTimestamp = "event_ts"
    }

}

extension MessageEvent: Replyable {

    public var toChannel: String {
        return channel
    }

    public var toUser: String {
        return user
    }

}
