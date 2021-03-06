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
    case accept(conversationUID: Int64)
    case reject(conversationUID: Int64)
    case repayRequest(conversationUID: Int64)
    case deleteRequest(conversationUID: Int64)
    case cancelRequest(conversationUID: Int64)
    case delete(conversationUID: Int64)
}

// MARK: - EndPointType

extension ConversationAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/conversations"

        switch self {
        case .create, .fetch:
            return basePath

        case .accept(let conversationUID):
            return basePath + "/\(conversationUID)/accept"

        case .reject(let conversationUID):
            return basePath + "/\(conversationUID)/reject"

        case .repayRequest(let conversationUID):
            return basePath + "/\(conversationUID)/request/repay"

        case .deleteRequest(let conversationUID):
            return basePath + "/\(conversationUID)/request/delete"

        case .cancelRequest(let conversationUID):
            return basePath + "/\(conversationUID)/request/cancel"

        case .delete(let conversationUID):
            return basePath + "/\(conversationUID)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create, .accept, .reject, .repayRequest, .deleteRequest, .cancelRequest:
            return .post

        case .fetch:
            return .get

        case .delete:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let opponentUID):
            let requestParameters = Coders.conversationCoder.encode(opponentUID: opponentUID)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)

        case .fetch, .accept, .reject, .repayRequest, .deleteRequest, .cancelRequest, .delete:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
