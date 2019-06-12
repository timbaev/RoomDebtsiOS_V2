//
//  Product.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol Product: AnyObject {

    // MARK: - Typealiases

    typealias UID = Int64

    // MARK: - Instance Properties

    var uid: UID { get set }

    var quantity: Double { get set }
    var name: String? { get set }
    var sum: Double { get set }

    var selectedUsers: [User] { get set }
}
