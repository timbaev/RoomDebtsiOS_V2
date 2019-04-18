//
//  CheckDateFormatter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 15/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class CheckDateFormatter {

    // MARK: - Type Properties

    static let shared = CheckDateFormatter()

    // MARK: - Instance Properties

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd.MM.yyyy HH:mm"

        return formatter
    }()

    // MARK: - Instance Methods

    func string(from date: Date) -> String {
        return self.formatter.string(from: date)
    }
}
