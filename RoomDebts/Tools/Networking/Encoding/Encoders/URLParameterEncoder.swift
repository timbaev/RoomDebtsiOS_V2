//
//  URLParameterEncoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    
    // MARK: - Instance Methods
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.missingURL
        }
        
        if var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponent.queryItems = parameters.map {
                return URLQueryItem(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            }
            
            urlRequest.url = urlComponent.url
        }
        
        if urlRequest.value(forHTTPHeaderField: HeaderKeys.contentType) == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: HeaderKeys.contentType)
        }
    }
}
