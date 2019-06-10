//
//  CheckUserListType.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum CheckUserListType {

    // MARK: - Enumeration Cases

    case unknown
    case check(uid: Int64)

    // MARK: - Instance Properties

    var rawValue: Int16 {
        switch self {
        case .unknown:
            return 0

        case .check:
            return 1
        }
    }

    var checkUID: Int64 {
        switch self {
        case .unknown:
            return 0

        case .check(let checkUID):
            return checkUID
        }
    }

    // MARK: - Initializers

    init?(rawValue: Int16, checkUID: Int64) {
        switch rawValue {
        case 0:
            self = .unknown

        case 1:
            self = .check(uid: checkUID)

        default:
            return nil
        }
    }
}

// MARK: - Hashable

extension CheckUserListType: Hashable {

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
