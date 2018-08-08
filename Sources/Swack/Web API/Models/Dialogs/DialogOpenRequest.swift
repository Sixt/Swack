//
//  DialogOpenRequest.swift
//  App
//
//  Created by franz busch on 04.07.18.
//

import Vapor

struct DialogOpenRequest: Content {

    let triggerId: String
    let dialog: Dialog

    enum CodingKeys: String, CodingKey {
        case triggerId = "trigger_id"
        case dialog
    }

    init(triggerId: String, dialog: Dialog) {
        self.triggerId = triggerId
        self.dialog = dialog
    }

}
