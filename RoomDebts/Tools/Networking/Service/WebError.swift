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

    // MARK: - Type Properties

    public static let unknown = WebError(code: .unknown)
    public static let aborted = WebError(code: .aborted)

    public static let tooManyRequests = WebError(code: .tooManyRequests)

    public static let connection = WebError(code: .connection)
    public static let timeOut = WebError(code: .timeOut)

    public static let security = WebError(code: .security)

    public static let badRequest = WebError(code: .badRequest)
    public static let badResponse = WebError(code: .badResponse)

    public static let unauthorized = WebError(code: .unauthorized)

    public static let resource = WebError(code: .resource)
    public static let server = WebError(code: .server)
    public static let access = WebError(code: .access)
    
    // MARK: - Instance Properties

    public var logDescription: String {
        var description: String

        switch self {
        case WebError.aborted:
            description = "WebError.aborted"

        case WebError.tooManyRequests:
            description = "WebError.tooManyRequests"

        case WebError.connection:
            description = "WebError.connection"

        case WebError.timeOut:
            description = "WebError.timeOut"

        case WebError.security:
            description = "WebError.security"

        case WebError.badRequest:
            description = "WebError.badRequest"

        case WebError.badResponse:
            description = "WebError.badResponse"

        case WebError.unauthorized:
            description = "WebError.unauthorized"

        case WebError.resource:
            description = "WebError.resource"

        case WebError.server:
            description = "WebError.server"

        case WebError.access:
            description = "WebError.access"

        default:
            description = "WebError.unknown"
        }

        if let data = self.data {
            description.append("data: \(data)")
        }

        return description
    }

    // MARK: -
    
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

// MARK: - Equatable

extension WebError: Equatable {

    // MARK: - Type Methods

    public static func == (left: WebError, right: WebError) -> Bool {
        return (left.code == right.code)
    }

    public static func != (left: WebError, right: WebError) -> Bool {
        return (left.code != right.code)
    }

    public static func ~= (left: WebError, right: WebError) -> Bool {
        return (left.code == right.code)
    }
}

// MARK: - CustomStringConvertible

extension WebError: CustomStringConvertible {

    // MARK: - Instance Properties

    public var description: String {
        return self.logDescription
    }
}
