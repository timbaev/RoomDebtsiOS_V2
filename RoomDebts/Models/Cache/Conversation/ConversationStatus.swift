//
//  ConversationStatus.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum ConversationStatus: String {

    // MARK: - Enumeration Cases

    case accepted
    case repayRequest
    case deleteRequest
    case invited

    // MARK: - Instance Methods

    func description(userIsCreator: Bool) -> String {
        switch self {
        case .accepted:
            return "Accepted".localized()

        case .repayRequest:
            if userIsCreator {
                return "Pending repay all debts request".localized()
            } else {
                return "Repay all debts request".localized()
            }

        case .invited:
            if userIsCreator {
                return "Waiting for confirmation".localized()
            } else {
                return "Confirm invitation".localized()
            }

        case .deleteRequest:
            if userIsCreator {
                return "Pending delete request".localized()
            } else {
                return "Delete request".localized()
            }
        }
    }
}
