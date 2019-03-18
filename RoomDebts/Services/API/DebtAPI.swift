//
//  DebtAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum DebtAPI {

    // MARK: - Enumeration Cases

    case create(form: CreateDebtForm)
    case fetch(conversationUID: Int64)
    case accept(debtUID: Int64)
    case reject(debtUID: Int64)
    case update(debtUID: Int64, form: CreateDebtForm)
    case deleteRequest(debtUID: Int64)
    case delete(debtUID: Int64)
}

// MARK: - EndPointType

extension DebtAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/debts"

        switch self {
        case .create, .fetch:
            return basePath

        case .accept(let debtUID):
            return basePath + "/\(debtUID)/accept"

        case .reject(let debtUID):
            return basePath + "/\(debtUID)/reject"

        case .update(let debtUID, _):
            return basePath + "/\(debtUID)"

        case .deleteRequest(let debtUID):
            return basePath + "/\(debtUID)/request"

        case .delete(let debtUID):
            return basePath + "/\(debtUID)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create, .accept, .reject:
            return .post

        case .fetch:
            return .get

        case .update:
            return .put

        case .deleteRequest, .delete:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let form):
            let requestParameters = Coders.debtCoder.encode(createForm: form)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)

        case .fetch(let conversationUID):
            let requestParameters = Coders.debtCoder.encode(conversationUID: conversationUID)

            return .requestParameters(bodyParameters: nil, urlParameters: requestParameters)

        case .accept, .reject, .deleteRequest, .delete:
            return .request

        case .update(_, let form):
            let requestParameters = Coders.debtCoder.encode(createForm: form)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
