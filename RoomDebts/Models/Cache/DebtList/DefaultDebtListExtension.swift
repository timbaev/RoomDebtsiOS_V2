//
//  DefaultDebtListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultDebtList: DebtList {

    // MARK: - Instance Properties

    var listType: DebtListType {
        get {
            return DebtListType(rawValue: self.listRawType, conversationUID: self.conversationUID) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
            self.conversationUID = newValue.conversationUID
        }
    }

    var count: Int {
        return self.rawDebts?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawDebts?.count ?? 0) == 0)
    }

    var allDebts: [Debt] {
        return (self.rawDebts?.array as? [Debt]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Debt {
        return self.rawDebts![index] as! Debt
    }

    // MARK: - Instance Methods

    func insert(debt: Debt, at index: Int) {
        if let debt = debt as? DefaultDebt {
            self.insertIntoRawDebts(debt, at: index)
        }
    }

    func removeDebt(at index: Int) -> Debt {
        let debt = self.rawDebts![index] as! Debt

        self.removeFromRawDebts(at: index)

        return debt
    }

    func append(debt: Debt) {
        if let debt = debt as? DefaultDebt {
            self.addToRawDebts(debt)
        }
    }

    func remove(debt: Debt) {
        if let debt = debt as? DefaultDebt {
            self.removeFromRawDebts(debt)
        }
    }

    func clearDebts() {
        if let debts = self.rawDebts {
            self.removeFromRawDebts(debts)
        }
    }
}
