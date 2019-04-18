//
//  DefaultCheckExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultCheckExtractor: CheckExtractor {

    // MARK: - Instance Properties

    let checkCoder: CheckCoder

    let userCoder: UserCoder
    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    func extractCheck(from json: JSON, cacheContext: CacheContext) throws -> Check {
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

        cacheContext.save()

        return check
    }

    func extractCheckList(from json: [JSON], withListType listType: CheckListType, cacheContext: CacheContext) throws -> CheckList {
        let checkList = cacheContext.checkListManager.firstOrNew(withListType: listType)

        checkList.clearChecks()

        try json.forEach { checkList.append(check: try self.extractCheck(from: $0, cacheContext: cacheContext)) }

        cacheContext.save()

        return checkList
    }
}
