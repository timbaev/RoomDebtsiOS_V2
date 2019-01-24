//
//  DefaultAccountService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultAccountService: AccountService {
    
    // MARK: - Instance Properties
    
    fileprivate let router = AuthRouter<AccountAPI>()
    
    // MARK: -
    
    let userAccountExtractor: UserAccountExtractor
    let accessCoder: AccessCoder
    
    // MARK: - Instance Methods
    
    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.create(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber), success: { json in
            if let access = self.accessCoder.decode(from: json) {
                KeychainManager.shared.access = access
                success()
            } else {
                failure(WebError(code: .badResponse))
            }
        }, failure: { webError in
            failure(webError)
        })
    }
    
    func confirm(code: String, success: @escaping (UserAccount) -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.confirm(code: code), success: { json in
            do {
                let userAccount = try self.userAccountExtractor.extractUserAccount(from: json, context: Services.cacheViewContext)
                
                success(userAccount)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: { error in
            failure(error)
        })
    }
}
