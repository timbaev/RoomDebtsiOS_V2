//
//  DefaultCheckListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultCheckList: CheckList {

    // MARK: - Instance Properties

    var listType: CheckListType {
        get {
            return CheckListType(rawValue: self.listRawType) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
        }
    }

    var count: Int {
        return self.rawChecks?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawChecks?.count ?? 0) == 0)
    }

    var checks: [Check] {
        return (self.rawChecks?.array as? [Check]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Check {
        return self.rawChecks![index] as! Check
    }

    // MARK: - Instance Methods

    func insert(check: Check, at index: Int) {
        if let check = check as? DefaultCheck {
            self.insertIntoRawChecks(check, at: index)
        }
    }

    func removeCheck(at index: Int) -> Check {
        let check = self.rawChecks![index] as! Check

        self.removeFromRawChecks(at: index)

        return check
    }

    func append(check: Check) {
        if let check = check as? DefaultCheck {
            self.addToRawChecks(check)
        }
    }

    func remove(check: Check) {
        if let check = check as? DefaultCheck {
            self.removeFromRawChecks(check)
        }
    }

    func clearChecks() {
        if let checks = self.rawChecks {
            self.removeFromRawChecks(checks)
        }
    }
}
