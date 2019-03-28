//
//  ConversationListType.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ConversationListType {

    // MARK: - Enumeration Cases

    case unknown
    case all

    // MARK: - Instance Properties

    var rawValue: Int16 {
        switch self {
        case .unknown:
            return 0

        case .all:
            return 1
        }
    }

    // MARK: - Initializers

    init?(rawValue: Int16) {
        switch rawValue {
        case 0:
            self = .unknown

        case 1:
            self = .all

        default:
            return nil
        }
    }
}

// MARK: - Hashable

extension ConversationListType: Hashable {

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
