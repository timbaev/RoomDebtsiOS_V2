//
//  DefaultCheckCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultCheckCoder: CheckCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let date = "date"
        static let store = "store"
        static let totalSum = "totalSum"
        static let address = "address"
        static let status = "status"
        static let imageURL = "imageURL"
    }

    // MARK: - Instance Methods

    func encode(form: CreateCheckForm) -> JSON? {
        return form.dictionary
    }

    func decode(check: Check, from json: JSON) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let date = Gloss.Decoder.decode(dateISO8601ForKey: JSONKeys.date)(json) else {
            return false
        }

        guard let store: String = JSONKeys.store <~~ json else {
            return false
        }

        guard let totalSum: Double = JSONKeys.totalSum <~~ json else {
            return false
        }

        guard let address: String = JSONKeys.address <~~ json else {
            return false
        }

        guard let rawStatus: String = JSONKeys.store <~~ json else {
            return false
        }

        guard let status = CheckStatus(rawValue: rawStatus) else {
            return false
        }

        let imageURL: URL? = JSONKeys.imageURL <~~ json

        check.uid = uid

        check.date = date
        check.store = store
        check.totalSum = totalSum
        check.address = address
        check.status = status
        check.imageURL = imageURL

        return true
    }
}
