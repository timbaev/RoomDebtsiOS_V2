//
//  CheckUserStatus.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum CheckUserStatus: String {

    // MARK: - Enumeration Cases

    case accepted
    case review
    case rejected

    // MARK: - Instance Properties

    var image: UIImage {
        switch self {
        case .accepted:
            return #imageLiteral(resourceName: "CheckApproveIcon.pdf")

        case .review:
            return #imageLiteral(resourceName: "CheckReviewIcon.pdf")

        case .rejected:
            return #imageLiteral(resourceName: "CheckRejectIcon.pdf")
        }
    }

    var rawLocalizedValue: String {
        return self.rawValue.localized()
    }
}
