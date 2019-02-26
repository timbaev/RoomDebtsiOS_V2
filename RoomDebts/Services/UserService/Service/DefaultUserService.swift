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

    func search(keyword: String, success: @escaping ([User]) -> (), failure: @escaping (WebError) -> ()) {
        self.router.jsonArray(.search(keyword: keyword), success: { json in
            do {
                let users = try self.userExtractor.extractUsers(from: json)

                success(users)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }
}
