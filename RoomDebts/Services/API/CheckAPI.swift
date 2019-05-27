//
//  CheckAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 12/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum CheckAPI {

    // MARK: - Enumeration Cases

    case create(form: CreateCheckForm)
    case fetch
    case fetchCheck(uid: Int64)
    case update(store: String, checkUID: Int64)
}

// MARK: - EndPointType

extension CheckAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/checks"

        switch self {
        case .create, .fetch:
            return basePath

        case .fetchCheck(let uid):
            return basePath + "/\(uid)"

        case let .update(_, checkUID):
            return basePath + "/\(checkUID)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create:
            return .post

        case .fetch, .fetchCheck:
            return .get

        case .update:
            return .put
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let form):
            return .requestParameters(bodyParameters: Coders.checkCoder.encode(form: form), urlParameters: nil)

        case let .update(store, _):
            return .requestParameters(bodyParameters: ["store": store], urlParameters: nil)

        case .fetch, .fetchCheck:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
