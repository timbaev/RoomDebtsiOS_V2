//
//  DefaultAccessCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 23/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultAccessCoder: AccessCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let expiredAt = "expiredAt"
    }

    // MARK: - Instance Methods

    func decode(from json: JSON) -> Access? {
        guard let accessToken: String = JSONKeys.accessToken <~~ json else {
            return nil
        }

        guard let refreshToken: String = JSONKeys.refreshToken <~~ json else {
            return nil
        }

        guard let expiredAt = Gloss.Decoder.decode(dateISO8601ForKey: JSONKeys.expiredAt)(json) else {
            return nil
        }

        return Access(accessToken: accessToken, refreshToken: refreshToken, expiredAt: expiredAt)
    }
}
