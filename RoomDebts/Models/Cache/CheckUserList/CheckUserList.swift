//
//  CheckUserList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckUserList: AnyObject {

    // MARK: - Instance Properties

    var listType: CheckUserListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var checkUsers: [CheckUser] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> CheckUser { get }

    // MARK: - Instance Methods

    func insert(checkUser: CheckUser, at index: Int)
    func removeCheckUser(at index: Int) -> CheckUser

    func append(checkUser: CheckUser)
    func remove(checkUser: CheckUser)

    func clearCheckUsers()
}
