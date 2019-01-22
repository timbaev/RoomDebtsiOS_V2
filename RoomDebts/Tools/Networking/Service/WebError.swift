//
//  WebError.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class WebError: Error {
    
    // MARK: - Nested Types
    
    public enum Code {
        
        // MARK: - Enumeration Cases
        
        case unknown
        case aborted
        
        case tooManyRequests
        
        case connection
        case timeOut
        
        case security
        
        case badRequest
        case badResponse
        
        case unauthorized
        
        case resource
        case server
        case access
    }
    
    // MARK: - Instance Properties
    
    let code: Code
    let data: Data?
    
    // MARK: -
    
    var message: String? {
        guard let data = self.data else {
            return nil
        }
        
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }
        
        guard let jsonBody = jsonResponse as? [String: Any] else {
            return nil
        }
        
        return jsonBody["reason"] as? String
    }
    
    // MARK: - Initializers
    
    init(code: Code, data: Data? = nil) {
        self.code = code
        self.data = data
    }
    
    convenience init?(fromStatusCode statusCode: Int, data: Data?) {
        guard statusCode >= 400 else {
            return nil
        }
        
        switch statusCode {
        case 429:
            self.init(code: .tooManyRequests, data: data)
            
        case 511:
            self.init(code: .connection, data: data)
            
        case 408,
             504:
            self.init(code: .timeOut, data: data)
            
        case 400,
             406,
             411,
             412,
             413,
             414,
             415,
             416,
             417,
             422,
             425,
             426,
             428,
             431,
             449:
            self.init(code: .badRequest, data: data)
            
        case 401:
            self.init(code: .unauthorized, data: data)
            
        case 404,
             405,
             409,
             410,
             423,
             434:
            self.init(code: .resource, data: data)
            
        case 424,
             444,
             500,
             501,
             502,
             503,
             505,
             506,
             507,
             508,
             509,
             510:
            self.init(code: .server, data: data)
            
        case 402,
             403,
             407,
             451:
            self.init(code: .access, data: data)
            
        default:
            self.init(code: .unknown, data: data)
        }
    }
}
