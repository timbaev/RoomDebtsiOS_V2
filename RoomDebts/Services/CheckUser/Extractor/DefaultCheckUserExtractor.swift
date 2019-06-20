//
//  DefaultCheckUserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

struct DefaultCheckUserExtractor: CheckUserExtractor {

    // MARK: - Instance Properties

    let cacheProvider: CacheProvider

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

        return checkUser
    }

    @discardableResult
    private func extractCheckUserList(from json: [JSON], withListType listType: CheckUserListType, cacheContext: CacheContext) throws -> CheckUserList {
        let checkUserList = cacheContext.checkUserListManager.firstOrNew(withListType: listType)

        checkUserList.clearCheckUsers()

        try json.forEach {
            checkUserList.append(checkUser: try self.extractCheckUser(from: $0, cacheContext: cacheContext))
        }

        return checkUserList
    }

    // MARK: - CheckUserExtractor

    func extractCheckUserList(from json: [JSON], withListType listType: CheckUserListType) -> Promise<CheckUserList> {
        return Promise(resolver: { seal in
            firstly {
                self.cacheProvider.captureModel()
            }.done { cacheSession in
                let backgroundContext = cacheSession.model.viewContext.createPrivateQueueChildContext()

                backgroundContext.perform(block: {
                    do {
                        try self.extractCheckUserList(from: json, withListType: listType, cacheContext: backgroundContext)

                        backgroundContext.save()

                        cacheSession.model.viewContext.performAndWait(block: {
                            cacheSession.model.viewContext.save()

                            seal.fulfill(cacheSession.model.viewContext.checkUserListManager.first(withListType: listType)!)
                        })
                    } catch {
                        DispatchQueue.main.async(execute: {
                            seal.reject(error)
                        })
                    }
                })
            }
        })
    }
}
