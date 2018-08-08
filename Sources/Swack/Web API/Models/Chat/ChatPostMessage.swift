//
//  ChatPost.swift
//  App
//
//  Created by franz busch on 14.05.18.
//

import Vapor

struct ChatPostMessage: Content {

    let channel: String
    let text: String

}
