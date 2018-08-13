//
//  AuthTestResponse.swift
//  Swack
//
//  Created by franz busch on 13.08.18.
//

import Foundation

struct AuthTestResponse: Decodable {

    let ok: Bool
    let url: String
    let team: String
    let user: String
    let teamId: String
    let userId: String

    private enum CodingKeys: String, CodingKey {
        case ok
        case url
        case team
        case user
        case userId = "user_id"
        case teamId = "team_id"
    }

}
