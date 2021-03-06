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

    private let router = AuthRouter<AccountAPI>()

    // MARK: -

    let userAccountExtractor: UserAccountExtractor
    let accessExtractor: AccessExtractor

    // MARK: - Instance Methods

    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.create(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber), success: { json in
            success()
        }, failure: { webError in
            failure(webError)
        })
    }

    func confirm(phoneNumber: String, code: String, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.confirm(phoneNumber: phoneNumber, code: code), success: { response in
            do {
                try self.accessExtractor.extract(from: response.content)

                let userAccount = try self.userAccountExtractor.extractUserAccount(from: response.content, context: Services.cacheViewContext)

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

    func signIn(phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.signIn(phoneNumber: phoneNumber), success: { json in
            success()
        }, failure: failure)
    }

    func uploadAvatar(image: UIImage, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.avatar(image: image.resized()), success: { response in
            do {
                let userAccount = try self.userAccountExtractor.extractUserAccount(from: response.content, context: Services.cacheViewContext)

                success(userAccount)
            } catch {
                failure(WebError(code: .aborted))
            }
        }, failure: failure)
    }

    func update(firstName: String, lastName: String, phoneNumber: String, success: @escaping (UserAccount, Bool) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.update(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber), success: { response in
            do {
                let userAccount = try self.userAccountExtractor.extractUserAccount(from: response.content, context: Services.cacheViewContext)

                success(userAccount, response.httpStatusCode == .accepted)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                    failure(WebError(code: .aborted))
                }
            }
        }, failure: failure)
    }

    func logout(success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.json(.logout, success: { response in
            success()
        }, failure: failure)
    }
}
