//
//  DefaultDebtExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultDebtExtractor: DebtExtractor {

    // MARK: - Instance Properties

    let debtCoder: DebtCoder

    let userCoder: UserCoder
    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    func extractDebt(from json: JSON, cacheContext: CacheContext) throws -> Debt {
        guard let debtUID = self.debtCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let debt = cacheContext.debtManager.firstOrNew(withUID: debtUID)

        guard self.debtCoder.decode(debt: debt, from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let creatorJSON = self.userCoder.creatorJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        let creator = try self.userExtractor.extractUser(from: creatorJSON, cacheContext: cacheContext)

        debt.creator = creator

        cacheContext.save()

        return debt
    }

    func extractDebtList(from json: [JSON], withListType listType: DebtListType, cacheContext: CacheContext) throws -> DebtList {
        let debtList = cacheContext.debtListManager.firstOrNew(withListType: listType)

        debtList.clearDebts()

        try json.forEach {
            debtList.append(debt: try self.extractDebt(from: $0, cacheContext: cacheContext))
        }

        cacheContext.save()

        return debtList
    }
}
