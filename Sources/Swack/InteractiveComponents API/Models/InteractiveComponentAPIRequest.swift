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

private enum InteractiveComponentType: String, Decodable {
    case dialogSubmission = "dialog_submission"
    case dialogCancellation = "dialog_cancellation"
}

internal enum InteractiveComponentAPIRequest: Decodable {
    case dialogSubmission(DialogSubmission)
    case dialogCancellation

    enum CodingKeys: String, CodingKey {
        case payload
    }

    enum PayloadCodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let payloadString = try container.decode(String.self, forKey: .payload)
        guard let payloadData = payloadString.data(using: .utf8) else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: [CodingKeys.payload], debugDescription: "Conversion to data failed"))
        }
        let jsonDecoder = JSONDecoder()
        let payload = try jsonDecoder.decode(InteractiveComponentAPIRequestPayload.self, from: payloadData)

        switch payload.type {
        case .dialogSubmission:
            self = try .dialogSubmission(jsonDecoder.decode(DialogSubmission.self, from: payloadData))
        case .dialogCancellation:
            self = .dialogCancellation
        }
    }
}

private struct InteractiveComponentAPIRequestPayload: Decodable {

    let type: InteractiveComponentType

}
