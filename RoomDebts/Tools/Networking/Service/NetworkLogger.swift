//
//  NetworkLogger.swift
//  ITISService
//
//  Created by Тимур Шафигуллин on 02/11/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

class NetworkLogger {
    
    static func log(request: URLRequest) {
        #if DEBUG
        print("\n - - - - - - - - - - REQUEST - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host) \n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(String(data: body, encoding: .utf8) ?? "")"
        }
        
        print(logOutput)
        #endif
    }
    
    static func log(response: URLResponse, data: Data) {
        #if DEBUG
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        print("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let statusCode = httpResponse.statusCode
        let urlString = response.url?.absoluteString ?? ""
        let body = String(data: data, encoding: .utf8) ?? ""
        
        let logOutput = """
        \(statusCode) \(urlString) \n
        \(body)
        """
        
        print(logOutput)
        #endif
    }
    
}
