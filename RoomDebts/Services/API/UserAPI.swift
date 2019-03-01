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
}

extension UserAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/users"

        switch self {
        case .search(let keyword):
            return basePath + "/search/\(keyword)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .search:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
