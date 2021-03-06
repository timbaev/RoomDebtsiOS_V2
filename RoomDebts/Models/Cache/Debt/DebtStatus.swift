//
//  DebtStatus.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum DebtStatus: String {

    // MARK: - Enumeration Cases

    case accepted
    case repaid
    case newRequest
    case editRequest
    case repayRequest
    case deleteRequest

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case .accepted:
            return "Accepted".localized()

        case .repaid:
            return "Repaid".localized()

        case .newRequest:
            return "New Request".localized()

        case .editRequest:
            return "Edit Request".localized()

        case .repayRequest:
            return "Repay Request".localized()

        case .deleteRequest:
            return "Delete Request".localized()
        }
    }
}
