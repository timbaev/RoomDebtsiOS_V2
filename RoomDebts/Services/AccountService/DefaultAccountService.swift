//
//  DefaultAccountService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct DefaultAccountService: AccountService {
    
    // MARK: - Instance Properties
    
    fileprivate let router = AuthRouter<AccountAPI>()
    
    // MARK: -
    
    let userAccountExtractor: UserAccountExtractor
    let accessExtractor: AccessExtractor
    
    // MARK: - Instance Methods
    
    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.create(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber), success: { json in
            success()
        }, failure: { webError in
            failure(webError)
        })
    }
    
    func confirm(phoneNumber: String, code: String, success: @escaping (UserAccount) -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.confirm(phoneNumber: phoneNumber, code: code), success: { json in
            do {
                try self.accessExtractor.extract(from: json)
                
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
    
    func signIn(phoneNumber: String, success: @escaping () -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.signIn(phoneNumber: phoneNumber), success: { json in
            success()
        }, failure: failure)
    }
    
    func uploadAvatar(image: UIImage, success: @escaping () -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.avatar(image: image), success: { json in
            do {
                try self.userAccountExtractor.extractUserAccount(from: json, context: Services.cacheViewContext)
                success()
            } catch {
                failure(WebError(code: .aborted))
            }
        }, failure: failure)
    }
}
