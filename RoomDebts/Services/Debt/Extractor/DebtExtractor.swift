//
//  DebtExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtExtractor {

    // MARK: - Instance Methods

    func extractDebt(from json: JSON, cacheContext: CacheContext) throws -> Debt
}
