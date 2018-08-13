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

public protocol Replyable {

    var toChannel: String { get }
    var toUser: String { get }

}

public enum MessageEventSubType: String, Decodable {
    case botMessage = "bot_message"
    case meMessage = "me_message"
    case messageChanged = "message_changed"
    case messageDeleted = "message_deleted"
    case messageReplied = "message_replied"
    case replyBroadcast = "reply_broadcast"
    case threadBroadcast = "thread_broadcast"
}

public enum MessageEventChannelType: String, Decodable {
    case appHome = "app_home"
    case im
    case channel
    case group
    case mpim
}

public struct MessageEvent: Event {

    public var type: EventType
    public var subtype: MessageEventSubType?
    public var timestamp: String
    public var user: String?
    public var botId: String?
    public var channel: String
    public var text: String
    public var channelType: MessageEventChannelType?

    private enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case timestamp = "ts"
        case user
        case botId = "bot_id"
        case channel
        case text
        case channelType = "channel_type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        type = try container.decode(EventType.self, forKey: .type)
        subtype = try? container.decode(MessageEventSubType.self, forKey: .subtype)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        user = try container.decodeIfPresent(String.self, forKey: .user)
        botId = try container.decodeIfPresent(String.self, forKey: .botId)
        channel = try container.decode(String.self, forKey: .channel)
        text = try container.decode(String.self, forKey: .text)
        channelType = try? container.decode(MessageEventChannelType.self, forKey: .channelType)
    }

}

extension MessageEvent: Replyable {

    public var toChannel: String {
        return channel
    }

    public var toUser: String {
        return user ?? botId ?? ""
    }

}
