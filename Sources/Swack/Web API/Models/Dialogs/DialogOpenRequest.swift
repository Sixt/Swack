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

struct DialogOpenRequest: Encodable {

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
