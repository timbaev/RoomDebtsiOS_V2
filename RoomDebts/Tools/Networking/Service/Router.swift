//
//  Router.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    // MARK: - Instance Properties
    
    fileprivate var task: URLSessionTask?
    
    // MARK: - Instance Methods
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: HeaderKeys.contentType)
            
        case .requestParameters(let bodyParameters, let urlParameters):
            try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            
        case .requestParametersAndHeader(let bodyParameters, let urlParameters, let additionalHeader):
            self.additionalHeader(additionalHeader, request: &request)
            try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            
        case .upload(let image, let imageName, let mimeType):
            let mediaData = MediaData(image: image, imageName: imageName, mimeType: mimeType)
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let contentType = "multipart/form-data; boundary=\(boundary)"
            
            self.additionalHeader([HeaderKeys.contentType: contentType], request: &request)
            
            ImageParameterEncoder.encode(urlRequest: &request, media: mediaData, boundary: boundary)
        }
        
        self.addAccessTokenHeader(to: &request)
        
        return request
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        if let bodyParameters = bodyParameters {
            try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
        }
        
        if let urlParameters = urlParameters {
            try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
        }
    }
    
    fileprivate func additionalHeader(_ additionalHeader: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeader else {
            return
        }
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    }
    
    fileprivate func addAccessTokenHeader(to request: inout URLRequest) {
        if let accessToken = KeychainManager.shared.access?.accessToken {
            request.setValue(accessToken, forHTTPHeaderField: HeaderKeys.authorization)
        }
    }
    
    // MARK: -
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse, data: Data?) -> Result<WebError> {
        if 200...299 ~= response.statusCode {
            return .success
        } else if let webError = WebError(fromStatusCode: response.statusCode, data: data) {
            return .failure(webError)
        } else {
            return .failure(WebError(code: .unknown))
        }
    }
    
    fileprivate func handleAccessToken(from response: HTTPURLResponse) {
        if let accessToken = response.allHeaderFields[HeaderKeys.authorization] as? String, var access = KeychainManager.shared.access {
            access.accessToken = accessToken
            
            KeychainManager.shared.access = access
        }
    }

    // MARK: -

    private func performRequest(_ route: EndPoint, success: @escaping (Data) -> (), failure: @escaping (WebError) -> ()) {
        let session = URLSession.shared

        guard let request = try? self.buildRequest(from: route) else {
            return failure(WebError(code: .badRequest))
        }

        NetworkLogger.log(request: request)

        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(WebError(code: .aborted))
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    failure(WebError(code: .aborted))
                }
                return
            }

            guard let responseData = data else {
                DispatchQueue.main.async {
                    failure(WebError(code: .badResponse))
                }
                return
            }

            self.handleAccessToken(from: response)

            NetworkLogger.log(response: response, data: responseData)

            let result = self.handleNetworkResponse(response, data: data)

            switch result {
            case .success:
                success(responseData)

            case .failure(let webError):
                DispatchQueue.main.async {
                    failure(webError)
                }
            }
        })

        self.task?.resume()
    }
    
    // MARK: -

    func jsonArray(_ route: EndPoint, success: @escaping ([JSON]) -> (), failure: @escaping (WebError) -> ()) {
        self.performRequest(route, success: { data in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    failure(WebError(code: .badResponse))
                }
                return
            }

            guard let responseArrayJSON = jsonObject as? [[String: Any]] else {
                DispatchQueue.main.async {
                    failure(WebError(code: .badResponse))
                }
                return
            }

            DispatchQueue.main.async {
                success(responseArrayJSON)
            }
        }, failure: failure)
    }
    
    func jsonObject(_ route: EndPoint, success: @escaping (JSON) -> (), failure: @escaping (WebError) -> ()) {
        self.performRequest(route, success: { data in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
                DispatchQueue.main.async {
                    failure(WebError(code: .badResponse))
                }
                return
            }

            guard let responseJSON = jsonObject as? [String: Any] else {
                DispatchQueue.main.async {
                    failure(WebError(code: .badResponse))
                }
                return
            }

            DispatchQueue.main.async {
                success(responseJSON)
            }
        }, failure: failure)
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
