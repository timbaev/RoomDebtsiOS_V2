//
//  CheckList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckList: AnyObject {

    // MARK: - Instance Properties

    var listType: CheckListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var checks: [Check] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Check { get }

    // MARK: - Instance Methods

    func insert(check: Check, at index: Int)
    func removeCheck(at index: Int) -> Check

    func append(check: Check)
    func remove(check: Check)

    func clearChecks()
}
