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
}

// MARK: - EndPointType

extension DebtAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/debts"

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
        case .create(let form):
            let requestParameters = Coders.debtCoder.encode(createForm: form)

            return .requestParameters(bodyParameters: requestParameters, urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
