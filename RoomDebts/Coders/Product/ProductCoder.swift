//
//  ProductCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ProductCoder: Coder {

    // MARK: - Instance Methods

    func usersJSON(from json: JSON) -> [JSON]?
    func productsJSON(from json: JSON) -> [JSON]?
    func selectedUsersJSON(from json: JSON) -> [JSON]?

    func decode(product: Product, from json: JSON) -> Bool
}
