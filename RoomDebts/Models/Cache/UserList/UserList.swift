//
//  UserList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserList: AnyObject {

    // MARK: - Instance Properties

    var listType: UserListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var allUsers: [User] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> User { get }

    // MARK: - Instance Methods

    func insert(user: User, at index: Int)
    func removeUser(at index: Int) -> User

    func append(user: User)
    func remove(user: User)

    func clearUsers()
}
