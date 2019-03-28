//
//  DebtListType.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 14/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum DebtListType {

    // MARK: - Enumeration Cases

    case unknown
    case conversation(uid: Int64)

    // MARK: - Instance Properties

    var rawValue: Int16 {
        switch self {
        case .unknown:
            return 0

        case .conversation:
            return 1
        }
    }

    var conversationUID: Int64 {
        switch self {
        case .unknown:
            return 0

        case .conversation(let conversationUID):
            return conversationUID
        }
    }

    // MARK: - Initializers

    init?(rawValue: Int16, conversationUID: Int64) {
        switch rawValue {
        case 0:
            self = .unknown

        case 1:
            self = .conversation(uid: conversationUID)

        default:
            return nil
        }
    }
}

// MARK: - Hashable

extension DebtListType: Hashable {

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
