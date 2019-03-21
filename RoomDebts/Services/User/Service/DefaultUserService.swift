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
}
