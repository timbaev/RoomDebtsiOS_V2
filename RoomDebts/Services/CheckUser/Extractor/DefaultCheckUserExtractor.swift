//
//  DefaultCheckUserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultCheckUserExtractor: CheckUserExtractor {

    // MARK: - Instance Properties

    let userExtractor: UserExtractor

    let checkUserCoder: CheckUserCoder

    // MARK: - Instance Methods

    private func extractCheckUser(from json: JSON, cacheContext: CacheContext) throws -> CheckUser {
        guard let checkUserUID = self.checkUserCoder.uid(from: json) else {
            throw WebError.badResponse
        }

        guard let userJSON = self.checkUserCoder.userJSON(from: json) else {
            throw WebError.badResponse
        }

        let checkUser = cacheContext.checkUserManager.firstOrNew(withUID: checkUserUID)

        guard self.checkUserCoder.decode(checkUser: checkUser, from: json) else {
            throw WebError.badResponse
        }

        checkUser.user = try self.userExtractor.extractUser(from: userJSON, cacheContext: cacheContext)

        cacheContext.save()

        return checkUser
    }

    // MARK: - CheckUserExtractor

    func extractCheckUserList(from json: [JSON], withListType listType: CheckUserListType, cacheContext: CacheContext) throws -> CheckUserList {
        let checkUserList = cacheContext.checkUserListManager.firstOrNew(withListType: listType)

        checkUserList.clearCheckUsers()

        try json.forEach {
            checkUserList.append(checkUser: try self.extractCheckUser(from: $0, cacheContext: cacheContext))
        }

        cacheContext.save()

        return checkUserList
    }
}
