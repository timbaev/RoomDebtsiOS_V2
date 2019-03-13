//
//  DefaultUserCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultUserCoder: UserCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let firstName = "firstName"
        static let lastName = "lastName"
        static let imageURL = "imageURL"

        static let creator = "creator"
        static let opponent = "opponent"
    }

    // MARK: - Instance Methods

    func decode(user: User, from json: JSON) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let firstName: String = JSONKeys.firstName <~~ json else {
            return false
        }

        guard let lastName: String = JSONKeys.lastName <~~ json else {
            return false
        }

        let imageURL: URL? = JSONKeys.imageURL <~~ json

        user.uid = uid

        user.firstName = firstName
        user.lastName = lastName
        user.imageURL = imageURL

        return true
    }

    func creatorJSON(from json: JSON) -> JSON? {
        return JSONKeys.creator <~~ json
    }

    func opponentJSON(from json: JSON) -> JSON? {
        return JSONKeys.opponent <~~ json
    }
}
