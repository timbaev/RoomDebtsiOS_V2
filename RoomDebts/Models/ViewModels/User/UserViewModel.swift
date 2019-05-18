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
    let borderColor: UIColor
    let nameFont: UIFont
    let nameColor: UIColor

    // MARK: - Initializers

    init(user: User, isSelected: Bool) {
        self.imageURL = user.imageURL
        self.name = user.firstName

        if isSelected {
            self.borderColor = Colors.selectedProductUser
            self.nameFont = Fonts.medium(ofSize: 12)
            self.nameColor = Colors.selectedProductUser
        } else {
            self.borderColor = Colors.clear
            self.nameFont = Fonts.light(ofSize: 12)
            self.nameColor = Colors.white
        }
    }
}
