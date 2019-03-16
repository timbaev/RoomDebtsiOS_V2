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
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create, .accept, .reject:
            return .post

        case .fetch:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let form):
            let requestParameters = Coders.debtCoder.encode(createForm: form)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)

        case .fetch(let conversationUID):
            let requestParamters = Coders.debtCoder.encode(conversationUID: conversationUID)

            return .requestParameters(bodyParameters: nil, urlParameters: requestParamters)

        case .accept, .reject:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
