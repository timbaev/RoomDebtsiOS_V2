//
//  ISO8601Formatter.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class ISO8601Formatter {

    // MARK: - Type Properties

    static let shared = ISO8601Formatter()

    // MARK: - Instance Properties

    private var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        return dateFormatter
    }()

    // MARK: - Instance Methods

    func string(from date: Date) -> String {
        return self.formatter.string(from: date)
    }
}
