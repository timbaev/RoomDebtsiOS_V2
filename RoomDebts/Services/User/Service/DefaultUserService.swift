//
//  DefaultUserService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserService: UserService {

    // MARK: - Instance Properties

    private let router = AuthRouter<UserAPI>()

    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    func search(keyword: String, success: @escaping ([User]) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonArray(.search(keyword: keyword), success: { response in
            do {
                let users = try self.userExtractor.extractSearchUsers(from: response.content)

                success(users)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }

    func fetchInviteList(response: @escaping (Swift.Result<UserList, WebError>) -> Void) {
        self.router.jsonArray(.invite, success: { httpResponse in
            do {
                let userList = try self.userExtractor.extractUserList(from: httpResponse.content, withListType: .all, cacheContext: Services.cacheViewContext)

                response(.success(userList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }
}
