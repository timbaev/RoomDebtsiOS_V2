//
//  ReviewDateFormatter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class ReviewDateFormatter {

    // MARK: - Type Properties

    static let shared = ReviewDateFormatter()

    // MARK: - Instance Properties

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        return formatter
    }()

    // MARK: - Instance Methods

    func string(from date: Date, reviewStatus: CheckUserStatus) -> String? {
        let calendar = Calendar.current

        let status = reviewStatus.rawValue

        if calendar.isDateInToday(date) {
            let dateComponents = calendar.dateComponents([.minute, .hour], from: date, to: Date())

            if let minutes = dateComponents.minute, let hours = dateComponents.hour {
                switch minutes {
                case 0:
                    return String(format: "%@ now".localized(), status)

                case let minutes where minutes < 60:
                    return String(format: "%@ %dm ago".localized(), status, minutes)

                default:
                    return String(format: "%@ %ds ago".localized(), status, hours)
                }
            } else {
                return nil
            }
        } else if calendar.isDateInYesterday(date) {
            self.dateFormatter.dateFormat = "h:mm a"

            return String(format: "%@ yesterday at %@".localized(), status, self.dateFormatter.string(from: date))
        } else if calendar.isDateInWeekend(date) {
            self.dateFormatter.dateFormat = "EEEE h:mm a"

            return String(format: "%@ at %@".localized(), status, self.dateFormatter.string(from: date))
        } else {
            self.dateFormatter.dateFormat = "MMMM dd"

            return String(format: "%@ at %@".localized(), status, self.dateFormatter.string(from: date))
        }
    }
}
