//
//  DefaultUserExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserExrtactor: UserExtractor {

    // MARK: - Instance Properties

    let userCoder: UserCoder

    // MARK: - Instance Methods

    func extractUsers(from json: [[String: Any]]) throws -> [User] {
        return try json.map {
            let user = DefaultUser()

            guard self.userCoder.decode(user: user, from: $0) else {
                throw WebError(code: .badResponse)
            }

            return user
        }
    }
}
