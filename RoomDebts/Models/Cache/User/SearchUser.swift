//
//  SearchUser.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class SearchUser: User {

    // MARK: - Instance Properties

    var uid: Int64 = 0
    var firstName: String?
    var lastName: String?
    var imageURL: URL?

    // MARK: -

    var fullName: String? {
        if let firstName = self.firstName, let lastName = self.lastName {
            return "\(firstName) \(lastName)"
        } else {
            return nil
        }
    }
}
