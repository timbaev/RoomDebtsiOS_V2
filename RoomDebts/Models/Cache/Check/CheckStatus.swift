//
//  CheckStatus.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum CheckStatus: String {

    // MARK: - Enumeration Cases

    case accepted
    case calculated
    case notCalculated
    case rejected

    // MARK: - Instance Properties

    var image: UIImage {
        switch self {
        case .accepted:
            return #imageLiteral(resourceName: "CheckApproveIcon.pdf")

        case .calculated:
            return #imageLiteral(resourceName: "CheckCalculatedIcon.pdf")

        case .notCalculated:
            return #imageLiteral(resourceName: "CheckReviewIcon.pdf")

        case .rejected:
            return #imageLiteral(resourceName: "CheckRejectIcon.pdf")
        }
    }

    var title: String {
        switch self {
        case .accepted:
            return "Accepted".localized()

        case .calculated:
            return "Calculated".localized()

        case .notCalculated:
            return "Not calculated".localized()

        case .rejected:
            return "Rejected".localized()
        }
    }
}
