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
    
    private let router = Router<EndPoint>()
    private let authRouter = Router<AuthAPI>()
    
    // MARK: - Instance Methods
    
    private func refresToken(with access: Access, success: @escaping (Access) -> (), failure: @escaping (WebError) -> ()) {
        self.authRouter.jsonObject(.refreshToken(refreshToken: access.refreshToken), success: { json in
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

    func jsonArray(_ route: EndPoint, success: @escaping ([JSON]) -> (), failure: @escaping (WebError) -> ()) {
        if let access = KeychainManager.shared.access {
            if access.expiredAt < Date() {
                self.refresToken(with: access, success: { [weak self] access in
                    KeychainManager.shared.access = access

                    self?.router.jsonArray(route, success: success, failure: failure)
                    }, failure: failure)
            } else {
                self.router.jsonArray(route, success: success, failure: failure)
            }
        } else {
            self.router.jsonArray(route, success: success, failure: failure)
        }
    }

    func jsonObject(_ route: EndPoint, success: @escaping (JSON) -> (), failure: @escaping (WebError) -> ()) {
        if let access = KeychainManager.shared.access {
            if access.expiredAt < Date() {
                self.refresToken(with: access, success: { [weak self] access in
                    KeychainManager.shared.access = access
                    
                    self?.router.jsonObject(route, success: success, failure: failure)
                }, failure: failure)
            } else {
                self.router.jsonObject(route, success: success, failure: failure)
            }
        } else {
            self.router.jsonObject(route, success: success, failure: failure)
        }
    }
    
    func cancel() {
        self.authRouter.cancel()
        self.router.cancel()
    }
}
