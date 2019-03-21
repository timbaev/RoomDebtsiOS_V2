//
//  NetworkRouter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

protocol NetworkRouter: AnyObject {
    
    associatedtype EndPoint: EndPointType
    
    // MARK: - Instance Methods

    func jsonArray(_ route: EndPoint, success: @escaping (HTTPResponse<[JSON]>) -> (), failure: @escaping (WebError) -> ())
    func jsonObject(_ route: EndPoint, success: @escaping (HTTPResponse<JSON>) -> (), failure: @escaping (WebError) -> ())
    func json(_ route: EndPoint, success: @escaping (HTTPResponse<Any?>) -> (), failure: @escaping (WebError) -> ())
    
    func cancel()
}
