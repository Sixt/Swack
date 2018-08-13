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

class ChatService {

    private let client: Client
    private let token: String

    init(client: Client, token: String) {
        self.client = client
        self.token = token
    }

    func post(_ message: ChatPostMessage) -> Future<Response> {
        return client.post("https://slack.com/api/chat.postMessage", headers: HTTPHeaders([("Authorization", "Bearer \(token)")])) { postRequest in
            try postRequest.content.encode(json: message)
        }
    }

    func postEphemeral(_ message: ChatPostEphemeralMessage) -> Future<Response> {
        return client.post("https://slack.com/api/chat.postEphemeral", headers: HTTPHeaders([("Authorization", "Bearer \(token)")])) { postRequest in
            try postRequest.content.encode(json: message)
        }
    }

}
