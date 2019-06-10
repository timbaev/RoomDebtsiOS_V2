//
//  UserViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct UserViewModel {

    // MARK: - Instance Properties

    let imageURL: URL?
    let name: String?
    let isSelected: Bool

    // MARK: - Initializers

    init(user: User, isSelected: Bool) {
        self.imageURL = user.imageURL
        self.name = user.firstName
        self.isSelected = isSelected
    }
}
