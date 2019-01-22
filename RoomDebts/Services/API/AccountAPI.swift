//
//  AccountEndPoint.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum AccountAPI {
    
    // MARK: - Enumeration Cases
    
    case create(firstName: String, lastName: String, phoneNumber: String)
}

// MARK: - EndPointType

extension AccountAPI: EndPointType {
    
    var baseURL: URL {
        guard let baseURL = URL(string: NetworkConfig.environment.rawValue) else {
            fatalError()
        }
        
        return baseURL
    }
    
    var path: String {
        return "/v1/account"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .create:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .create(let firstName, let lastName, let phoneNumber):
            return .requestParameters(
                bodyParameters: Coders.userAccountCoder.encode(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber),
                urlParameters: nil
            )
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }    
}
