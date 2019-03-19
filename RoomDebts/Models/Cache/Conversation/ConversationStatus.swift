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
    case invited

    // MARK: - Instance Methods

    func description(userIsCreator: Bool) -> String {
        switch self {
        case .accepted:
            return "Accepted".localized()

        case .repayRequest:
            if userIsCreator {
                return "Pending confirmation of request to repay all debts".localized()
            } else {
                return "Repay all debts request".localized()
            }

        case .invited:
            if userIsCreator {
                return "Waiting for confirmation".localized()
            } else {
                return "Confirm invitation".localized()
            }
        }
    }
}
