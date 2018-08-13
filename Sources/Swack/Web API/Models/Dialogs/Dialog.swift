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

public struct Dialog: Encodable {

    public let title: String
    public let callbackId: String
    public let elements: [AnyDialogElement]
    public let submitLabel: String
    public let notifyOnCancel: Bool

    public var onSubmission: (DialogSubmission) -> Void

    enum CodingKeys: String, CodingKey {
        case title
        case callbackId = "callback_id"
        case elements
        case submitLabel = "submit_label"
        case notifyOnCancel = "notify_on_cancel"
    }

    public init(title: String, callbackId: String, elements: [DialogElement], submitLabel: String, notifyOnCancel: Bool, onSubmission: @escaping (DialogSubmission) -> Void) {
        self.title = title
        self.callbackId = callbackId
        self.elements = elements.map { AnyDialogElement($0) }
        self.submitLabel = submitLabel
        self.notifyOnCancel = notifyOnCancel
        self.onSubmission = onSubmission
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encode(callbackId, forKey: .callbackId)
        try container.encode(submitLabel, forKey: .submitLabel)
        try container.encode(notifyOnCancel, forKey: .notifyOnCancel)
        try container.encode(elements, forKey: .elements)
    }

}
