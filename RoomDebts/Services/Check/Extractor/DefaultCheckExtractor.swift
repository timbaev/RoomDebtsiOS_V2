//
//  DefaultCheckExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

struct DefaultCheckExtractor: CheckExtractor {

    // MARK: - Instance Properties

    let cacheProvider: CacheProvider

    let checkCoder: CheckCoder
    let userCoder: UserCoder

    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    private func extractCheck(from json: JSON, cacheContext: CacheContext) throws -> Check {
        guard let checkUID = self.checkCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let check = cacheContext.checkManager.firstOrNew(withUID: checkUID)

        guard self.checkCoder.decode(check: check, from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let creatorJSON = self.userCoder.creatorJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        let creator = try self.userExtractor.extractUser(from: creatorJSON, cacheContext: cacheContext)

        check.creator = creator

        return check
    }

    @discardableResult
    private func extractCheckList(from json: [JSON], withListType listType: CheckListType, cacheContext: CacheContext) throws -> CheckList {
        let checkList = cacheContext.checkListManager.firstOrNew(withListType: listType)

        checkList.clearChecks()

        try json.forEach { checkList.append(check: try self.extractCheck(from: $0, cacheContext: cacheContext)) }

        return checkList
    }

    // MARK: - CheckExtractor

    func extractCheck(from json: JSON) -> Promise<Check> {
        return Promise(resolver: { seal in
            firstly {
                self.cacheProvider.captureModel()
            }.done { cacheSession in
                let backgroundContext = cacheSession.model.viewContext.createPrivateQueueChildContext()

                backgroundContext.perform(block: {
                    do {
                        let checkUID = try self.extractCheck(from: json, cacheContext: backgroundContext).uid

                        backgroundContext.save()

                        cacheSession.model.viewContext.performAndWait(block: {
                            cacheSession.model.viewContext.save()

                            seal.fulfill(cacheSession.model.viewContext.checkManager.first(withUID: checkUID)!)
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

    func extractCheckList(from json: [JSON], withListType listType: CheckListType) -> Promise<CheckList> {
        return Promise(resolver: { seal in
            firstly {
                self.cacheProvider.captureModel()
            }.done { cacheSession in
                let backgroundContext = cacheSession.model.viewContext.createPrivateQueueChildContext()

                backgroundContext.perform(block: {
                    do {
                        try self.extractCheckList(from: json, withListType: listType, cacheContext: backgroundContext)

                        backgroundContext.save()

                        cacheSession.model.viewContext.performAndWait(block: {
                            cacheSession.model.viewContext.save()

                            seal.fulfill(cacheSession.model.viewContext.checkListManager.first(withListType: listType)!)
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
