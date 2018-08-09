//
//  DialogSubmission.swift
//  App
//
//  Created by franz busch on 15.07.18.
//

import Vapor

public struct Team: Content {

    public let id: String
    public let domain: String

}

public struct User: Content {

    public let id: String
    public let name: String

}

public struct Channel: Content {

    public let id: String
    public let name: String

}

public struct DialogSubmission: Content {

    public let type = "dialog_submission"
    public let submission: [String: String]
    public let callbackId: String
    public let team: Team
    public let user: User
    public let channel: Channel
    public let actionTimestamp: String
    public let responseURL: String

    enum CodingKeys: String, CodingKey {
        case type
        case submission
        case callbackId = "callback_id"
        case team
        case user
        case channel
        case actionTimestamp = "action_ts"
        case responseURL = "response_url"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard (try container.decode(String.self, forKey: .type)) == type else {
            throw DecodingError.valueNotFound(String.self, .init(codingPath: [CodingKeys.type], debugDescription: "Type mismatch"))
        }
        
        submission = try container.decode([String: String].self, forKey: .submission)
        callbackId = try container.decode(String.self, forKey: .callbackId)
        team = try container.decode(Team.self, forKey: .team)
        user = try container.decode(User.self, forKey: .user)
        channel = try container.decode(Channel.self, forKey: .channel)
        actionTimestamp = try container.decode(String.self, forKey: .actionTimestamp)
        responseURL = try container.decode(String.self, forKey: .responseURL)
    }

    public func value(for element: DialogElement) -> String? {
        return submission[element.name]
    }

    public subscript(element: DialogElement) -> String? {
        return value(for: element)
    }

}

extension DialogSubmission: Replyable {

    public var toChannel: String {
        return channel.id
    }

    public var toUser: String {
        return user.id
    }

}
