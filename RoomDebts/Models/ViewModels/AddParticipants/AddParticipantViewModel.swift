//
//  AddParticipantViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct AddParticipantViewModel {

    // MARK: - Instance Properties

    let firstName: String?
    let lastName: String?
    let imageURL: URL?

    let nameTextColor: UIColor
    let isUserInteractionEnabled: Bool

    // MARK: -

    var fullName: String? {
        if let firstName = self.firstName, let lastName = self.lastName {
            return "\(firstName) \(lastName)"
        } else {
            return nil
        }
    }

    // MARK: - Initializers

    init(user: User, isEnabled: Bool) {
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.imageURL = user.imageURL

        if isEnabled {
            self.nameTextColor = Colors.white
            self.isUserInteractionEnabled = true
        } else {
            self.nameTextColor = Colors.white.withAlphaComponent(0.5)
            self.isUserInteractionEnabled = false
        }
    }
}
