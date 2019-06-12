//
//  User.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol User: AnyObject {

    // MARK: - Typealiases

    typealias UID = Int64

    // MARK: - Instance Properties

    var uid: UID { get set }

    var firstName: String? { get set }
    var lastName: String? { get set }
    var imageURL: URL? { get set }

    var fullName: String? { get }
}
