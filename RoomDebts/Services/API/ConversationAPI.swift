//
//  ConversationAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ConversationAPI {

    // MARK: - Enumeration Cases

    case create(opponentUID: Int64)
}

// MARK: - EndPointType

extension ConversationAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/conversations"

        switch self {
        case .create:
            return basePath
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let opponentUID):
            let requestParameters = Coders.conversationCoder.encode(opponentUID: opponentUID)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
