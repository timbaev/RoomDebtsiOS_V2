//
//  DebtDateFormatter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 07/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class DebtDateFormatter {

    // MARK: - Type Properties

    static let shared = DebtDateFormatter()

    // MARK: - Instance Properties

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd.MM.yyyy"

        return formatter
    }()

    // MARK: - Instance Methods

    func string(from date: Date) -> String {
        return self.formatter.string(from: date)
    }
}
