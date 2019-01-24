//
//  AuthAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum AuthAPI {
    
    // MARK: - Enumeration Cases
    
    case refreshToken(refreshToken: String)
}

// MARK: - EndPointType

extension AuthAPI: EndPointType {
    
    // MARK: - Instance Properties
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/v1/account/token"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .refreshToken:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .refreshToken(let refreshToken):
            return .requestParameters(bodyParameters: ["refreshToken": refreshToken], urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
