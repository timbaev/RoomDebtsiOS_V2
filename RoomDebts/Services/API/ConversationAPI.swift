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
    case fetch
}

// MARK: - EndPointType

extension ConversationAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/conversations"

        switch self {
        case .create, .fetch:
            return basePath
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create:
            return .post

        case .fetch:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let opponentUID):
            let requestParameters = Coders.conversationCoder.encode(opponentUID: opponentUID)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)

        case .fetch:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
