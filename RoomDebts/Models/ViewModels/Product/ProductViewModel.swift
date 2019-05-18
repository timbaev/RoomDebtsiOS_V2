//
//  ProductViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct ProductViewModel {

    // MARK: - Instance Properties

    let name: String?
    let price: String
    let quantity: String
    let users: [UserViewModel]

    // MARK: - Initializers

    init(product: Product, checkUsers: [User]) {
        self.name = product.name
        self.price = String(format: "%.2f₽", product.sum)
        self.quantity = String(format: "%.2f", product.quantity)

        self.users = checkUsers.map { user in
            return UserViewModel(user: user,
                                 isSelected: product.selectedUsers.contains(where: { $0.uid == user.uid }))
        }
    }
}
