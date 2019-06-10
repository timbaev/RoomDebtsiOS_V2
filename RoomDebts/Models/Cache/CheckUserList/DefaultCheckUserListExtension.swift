//
//  DefaultCheckUserListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultCheckUserList: CheckUserList {

    // MARK: - Instance Properties

    var listType: CheckUserListType {
        get {
            return CheckUserListType(rawValue: self.listRawType, checkUID: self.checkUID) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
            self.checkUID = newValue.checkUID
        }
    }

    var count: Int {
        return self.rawCheckUsers?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawCheckUsers?.count ?? 0) == 0)
    }

    var checkUsers: [CheckUser] {
        return (self.rawCheckUsers?.array as? [CheckUser]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> CheckUser {
        return self.rawCheckUsers![index] as! CheckUser
    }

    // MARK: - Instance Methods

    func insert(checkUser: CheckUser, at index: Int) {
        if let checkUser = checkUser as? DefaultCheckUser {
            self.insertIntoRawCheckUsers(checkUser, at: index)
        }
    }

    func removeCheckUser(at index: Int) -> CheckUser {
        let checkUser = self.rawCheckUsers![index] as! CheckUser

        self.removeFromRawCheckUsers(at: index)

        return checkUser
    }

    func append(checkUser: CheckUser) {
        if let checkUser = checkUser as? DefaultCheckUser {
            self.addToRawCheckUsers(checkUser)
        }
    }

    func remove(checkUser: CheckUser) {
        if let checkUser = checkUser as? DefaultCheckUser {
            self.removeFromRawCheckUsers(checkUser)
        }
    }

    func clearCheckUsers() {
        if let checkUsers = self.rawCheckUsers {
            self.removeFromRawCheckUsers(checkUsers)
        }
    }
}
