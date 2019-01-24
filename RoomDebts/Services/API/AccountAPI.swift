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
    case confirm(code: String)
}

// MARK: - EndPointType

extension AccountAPI: EndPointType {
    
    var path: String {
        let basePath = "/v1/account"
        
        switch self {
        case .create:
            return basePath
            
        case .confirm:
            return basePath + "/confirm"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .create, .confirm:
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
            
        case .confirm(let code):
            return .requestParameters(bodyParameters: Coders.confirmCoder.encode(code: code), urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }    
}
