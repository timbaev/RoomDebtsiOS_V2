//
//  DefaultCheckUserExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultCheckUser: CheckUser {

    // MARK: - Instance Properties

    var status: CheckUserStatus? {
        get {
            if let rawStatus = self.rawStatus {
                return CheckUserStatus(rawValue: rawStatus)
            } else {
                return nil
            }
        }

        set {
            self.rawStatus = newValue?.rawValue
        }
    }

    var user: User? {
        get {
            return self.rawUser
        }

        set {
            if let newValue = newValue as? DefaultUser {
                self.rawUser = newValue
            } else {
                self.rawUser = nil
            }
        }
    }
}
