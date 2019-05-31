//
//  UserAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum UserAPI {

    // MARK: - Enumeration Cases

    case search(keyword: String)
    case invite
}

extension UserAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/users"

        switch self {
        case .search(let keyword):
            return basePath + "/search/\(keyword)"

        case .invite:
            return basePath + "/invite"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .search, .invite:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .search, .invite:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
