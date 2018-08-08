//
//  ChatPostEphemeralMessage.swift
//  App
//
//  Created by franz busch on 15.07.18.
//

import Vapor

struct ChatPostEphemeralMessage: Content {

    let channel: String
    let user: String
    let text: String

}
