//
//  DefaultProductExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultProduct: Product {

    // MARK: - Instance Properties

    var selectedUsers: [User] {
        get {
            return self.rawSelectedUsers?.array as? [User] ?? []
        }

        set {
            self.rawSelectedUsers = NSOrderedSet(array: newValue)
        }
    }
}
