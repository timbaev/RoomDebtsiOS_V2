//
//  DefaultUserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserExrtactor: UserExtractor {

    // MARK: - Instance Properties

    let userCoder: UserCoder

    // MARK: - Instance Methods

    func extractSearchUsers(from json: [[String: Any]]) throws -> [User] {
        return try json.map {
            let user = SearchUser()

            guard self.userCoder.decode(user: user, from: $0) else {
                throw WebError(code: .badResponse)
            }

            return user
        }
    }

    func extractUser(from json: [String: Any], cacheContext: CacheContext) throws -> User {
        guard let userUID = self.userCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let user = cacheContext.userManager.firstOrNew(withUID: userUID)

        guard self.userCoder.decode(user: user, from: json) else {
            throw WebError(code: .badResponse)
        }

        cacheContext.save()

        return user
    }

    func extractUserList(from json: [JSON], withListType listType: UserListType, cacheContext: CacheContext) throws -> UserList {
        let userList = cacheContext.userListManager.firstOrNew(withListType: listType)

        userList.clearUsers()

        try json.forEach {
            userList.append(user: try self.extractUser(from: $0, cacheContext: cacheContext))
        }

        cacheContext.save()

        return userList
    }
}
