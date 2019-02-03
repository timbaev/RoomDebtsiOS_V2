//
//  JSONParameterEncoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    // MARK: - Instance Methods
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: HeaderKeys.contentType) == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
