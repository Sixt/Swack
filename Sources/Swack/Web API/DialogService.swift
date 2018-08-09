//
//  DialogService.swift
//  App
//
//  Created by franz busch on 04.07.18.
//

import Vapor

class DialogService {

    private let client: Client
    private let token: String

    init(client: Client, token: String) {
        self.client = client
        self.token = token
    }

    func post(_ dialogOpenRequest: DialogOpenRequest) -> Future<Response> {
        return client.post("https://slack.com/api/dialog.open", headers: HTTPHeaders([("Authorization", "Bearer \(token)")])) { postRequest in
            try postRequest.content.encode(json: dialogOpenRequest)
        }
    }

}
