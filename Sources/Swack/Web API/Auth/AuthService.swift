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

class AuthService {

    private let client: Client
    private let token: String

    init(client: Client, token: String) {
        self.client = client
        self.token = token
    }

    func test() -> Future<AuthTestResponse> {
        return client.post("https://slack.com/api/chat.postMessage", headers: HTTPHeaders([("Authorization", "Bearer \(token)")])).flatMap { response in
            return try response.content.decode(AuthTestResponse.self)
        }
    }

}
