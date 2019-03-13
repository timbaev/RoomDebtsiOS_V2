//
//  DefaultDebtExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultDebt: Debt {

    // MARK: - Instance Properties

    var debtDescription: String? {
        get {
            return self.rawDescription
        }

        set {
            self.rawDescription = newValue
        }
    }

    var creator: User? {
        get {
            return self.rawCreator
        }

        set {
            if let newValue = newValue as? DefaultUser {
                self.rawCreator = newValue
            } else {
                self.rawCreator = nil
            }
        }
    }

    var status: DebtStatus? {
        get {
            if let rawStatus = self.rawStatus {
                return DebtStatus(rawValue: rawStatus)
            } else {
                return nil
            }
        }

        set {
            self.rawStatus = newValue?.rawValue
        }
    }
}
