//
//  DebtList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtList: AnyObject {

    // MARK: - Instance Properties

    var listType: DebtListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var allDebts: [Debt] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Debt { get }

    // MARK: - Instance Methods

    func insert(debt: Debt, at index: Int)
    func removeDebt(at index: Int) -> Debt

    func append(debt: Debt)
    func remove(debt: Debt)

    func clearDebts()
}
