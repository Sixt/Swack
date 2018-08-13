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

import Foundation

public enum EventsAPIRequestType: String, Decodable {
    case urlVerification
    case eventCallback
}

public struct EventsAPIRequest: Decodable {

    public var token: String
    public var type: EventsAPIRequestType

    public var challenge: String?

    public var teamId: String?
    public var apiAppId: String?
    public var eventId: String?
    public var eventTime: Int?
    public var event: Event?

    enum CodingKeys: String, CodingKey {
        case token
        case type
        case challenge
        case teamId = "team_id"
        case apiAppId = "api_app_id"
        case eventId = "event_id"
        case eventTime = "event_time"
        case event
    }

    enum EventCodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        type = try container.decode(EventsAPIRequestType.self, forKey: .type)

        challenge = try container.decodeIfPresent(String.self, forKey: .challenge)

        teamId = try container.decodeIfPresent(String.self, forKey: .teamId)
        apiAppId = try container.decodeIfPresent(String.self, forKey: .apiAppId)
        eventId = try container.decodeIfPresent(String.self, forKey: .eventId)
        eventTime = try container.decodeIfPresent(Int.self, forKey: .eventTime)

        if let eventContainer = try? container.nestedContainer(keyedBy: EventCodingKeys.self, forKey: .event) {
            let eventType = try eventContainer.decode(EventType.self, forKey: .type)

            switch eventType {
            case .message:
                event = try container.decode(MessageEvent.self, forKey: .event)
            default:
                break
            }
        }
    }

}
