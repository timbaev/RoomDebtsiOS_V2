//
//  MockDebtList.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockDebtList: DebtList {

    // MARK: - Instance Properties

    var listType: DebtListType = .unknown
    var count: Int = 0
    var isEmpty: Bool = false
    var allDebts: [Debt] = []

    // MARK: - Subscripts

    subscript(index: Int) -> Debt {
        return MockDebt()
    }

    // MARK: - Instance Methods

    func insert(debt: Debt, at index: Int) {

    }

    func removeDebt(at index: Int) -> Debt {
        return MockDebt()
    }

    func append(debt: Debt) {

    }

    func remove(debt: Debt) {

    }

    func clearDebts() {
        
    }
}
