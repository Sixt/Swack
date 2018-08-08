//
//  InteractiveComponentAPIRequest.swift
//  App
//
//  Created by franz busch on 15.07.18.
//

import Vapor

private enum InteractiveComponentType: String, Content {
    case dialogSubmission = "dialog_submission"
    case dialogCancellation = "dialog_cancellation"
}

internal enum InteractiveComponentAPIRequest: Content {
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

    func encode(to encoder: Encoder) throws {
        
    }
}

private struct InteractiveComponentAPIRequestPayload: Content {

    let type: InteractiveComponentType

}
