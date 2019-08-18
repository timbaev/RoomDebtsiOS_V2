//
//  ConversationVisitAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ConversationVisitAPI {

    // MARK: - Enumeration Cases

    case update(conversationUID: Int64)
}

// MARK: - EndPointType

extension ConversationVisitAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "v1/conversation/visit"

        switch self {
        case .update:
            return basePath
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .update:
            return .put
        }
    }

    var task: HTTPTask {
        switch self {
        case .update(let conversationUID):
            let requestParamters: [String: Any] = ["conversationID": conversationUID]

            return .requestParameters(bodyParameters: nil, urlParameters: requestParamters)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
