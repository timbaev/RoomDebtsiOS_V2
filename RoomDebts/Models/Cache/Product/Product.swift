//
//  Product.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol Product {

    // MARK: - Instance Properties

    var uid: Int64 { get set }

    var quantity: Int16 { get set }
    var name: String? { get set }
    var sum: Double { get set }

    var selectedUsers: [User] { get set }
}