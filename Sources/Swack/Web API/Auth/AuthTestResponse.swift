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

struct AuthTestResponse: Decodable {

    let ok: Bool
    let url: String
    let team: String
    let user: String?
    let teamId: String?
    let userId: String?

    private enum CodingKeys: String, CodingKey {
        case ok
        case url
        case team
        case user
        case userId = "user_id"
        case teamId = "team_id"
    }

}
