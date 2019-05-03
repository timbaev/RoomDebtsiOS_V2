//
//  DefaultProductCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

class DefaultProductCoder: ProductCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let users = "users"
        static let selectedUsers = "selectedUsers"
        static let products = "products"

        static let quantity = "quantity"
        static let name = "name"
        static let sum = "sum"
    }

    // MARK: - Instance Methods

    func usersJSON(from json: JSON) -> [JSON]? {
        return JSONKeys.users <~~ json
    }

    func productsJSON(from json: JSON) -> [JSON]? {
        return JSONKeys.products <~~ json
    }

    func selectedUsersJSON(from json: JSON) -> [JSON]? {
        return JSONKeys.selectedUsers <~~ json
    }

    func decode(product: Product, from json: JSON) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let quantity: Int16 = JSONKeys.quantity <~~ json else {
            return false
        }

        guard let name: String = JSONKeys.name <~~ json else {
            return false
        }

        guard let sum: Double = JSONKeys.sum <~~ json else {
            return false
        }

        product.uid = uid

        product.quantity = quantity
        product.name = name
        product.sum = sum

        return true
    }
}
