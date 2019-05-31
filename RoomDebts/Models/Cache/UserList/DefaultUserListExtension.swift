//
//  DefaultUserListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultUserList: UserList {

    // MARK: - Instance Properties

    var listType: UserListType {
        get {
            return UserListType(rawValue: self.listRawType) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
        }
    }

    var count: Int {
        return self.rawUsers?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawUsers?.count ?? 0) == 0)
    }

    var allUsers: [User] {
        return (self.rawUsers?.array as? [User]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> User {
        return self.rawUsers![index] as! User
    }

    // MARK: - Instance Methods

    func insert(user: User, at index: Int) {
        if let user = user as? DefaultUser {
            self.insertIntoRawUsers(user, at: index)
        }
    }

    func removeUser(at index: Int) -> User {
        let user = self.rawUsers![index] as! User

        self.removeFromRawUsers(at: index)

        return user
    }

    func append(user: User) {
        if let user = user as? DefaultUser {
            self.addToRawUsers(user)
        }
    }

    func remove(user: User) {
        if let user = user as? DefaultUser {
            self.removeFromRawUsers(user)
        }
    }

    func clearUsers() {
        if let users = self.rawUsers {
            self.removeFromRawUsers(users)
        }
    }
}
