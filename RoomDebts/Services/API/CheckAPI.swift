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
}

// MARK: - EndPointType

extension CheckAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/checks"

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
            return .requestParameters(bodyParameters: Coders.checkCoder.encode(form: form), urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
