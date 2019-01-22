//
//  ParameterEncoding.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ParameterEncoding {
    
    // MARK: - Enumeration Cases
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    // MARK: - Instance Methods
    
    func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else {
                    return
                }
                
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else {
                    return
                }
                
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters, let urlParameters = urlParameters else {
                    return
                }
                
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

