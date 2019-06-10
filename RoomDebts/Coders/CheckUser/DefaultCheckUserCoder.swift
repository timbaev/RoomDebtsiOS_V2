//
//  DefaultCheckUserCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 09/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultCheckUserCoder: CheckUserCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let user = "user"

        static let status = "status"
        static let comment = "comment"
        static let total = "total"
        static let reviewDate = "reviewDate"
    }

    // MARK: - Instance Methods

    func decode(checkUser: CheckUser, from json: JSON) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let rawStatus: String = JSONKeys.status <~~ json else {
            return false
        }

        guard let status = CheckUserStatus(rawValue: rawStatus) else {
            return false
        }

        guard let total: Double = JSONKeys.total <~~ json else {
            return false
        }

        checkUser.uid = uid

        checkUser.status = status
        checkUser.total = total

        checkUser.comment = JSONKeys.comment <~~ json
        checkUser.reviewDate = Gloss.Decoder.decode(dateISO8601ForKey: JSONKeys.reviewDate)(json)

        return true
    }

    func userJSON(from json: JSON) -> JSON? {
        return JSONKeys.user <~~ json
    }
}
