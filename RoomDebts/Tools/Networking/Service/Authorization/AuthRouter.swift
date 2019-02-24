//
//  AuthRouter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class AuthRouter<EndPoint: EndPointType>: NetworkRouter {
    
    // MARK: - Instance Properties
    
    fileprivate let router = Router<EndPoint>()
    fileprivate let authRouter = Router<AuthAPI>()
    
    // MARK: - Instance Methods
    
    fileprivate func refresToken(with access: Access, success: @escaping (Access) -> (), failure: @escaping (WebError) -> ()) {
        self.authRouter.request(.refreshToken(refreshToken: access.refreshToken), success: { json in
            if let access = Coders.accessCoder.decode(from: json) {
                success(access)
            } else {
                failure(WebError(code: .unauthorized))
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    // MARK: -
    
    func request(_ route: EndPoint, success: @escaping (JSON) -> (), failure: @escaping (WebError) -> ()) {
        if let access = KeychainManager.shared.access {
            if access.expiredAt < Date() {
                self.refresToken(with: access, success: { [weak self] access in
                    KeychainManager.shared.access = access
                    
                    self?.router.request(route, success: success, failure: failure)
                }, failure: failure)
            } else {
                self.router.request(route, success: success, failure: failure)
            }
        } else {
            self.router.request(route, success: success, failure: failure)
        }
    }
    
    func cancel() {
        self.authRouter.cancel()
        self.router.cancel()
    }
}
