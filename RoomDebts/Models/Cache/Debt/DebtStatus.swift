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
    case newRequest
    case editRequest
    case closeRequest
    case deleteRequest

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case .accepted:
            return "Accepted".localized()

        case .newRequest:
            return "New Request".localized()

        case .editRequest:
            return "Edit Request".localized()

        case .closeRequest:
            return "Close Request".localized()

        case .deleteRequest:
            return "Delete Request".localized()
        }
    }
}
