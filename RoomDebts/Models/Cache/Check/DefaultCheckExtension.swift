//
//  DefaultCheckExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultCheck: Check {

    // MARK: - Instance Properties

    var status: CheckStatus? {
        get {
            if let rawStatus = self.rawStatus {
                return CheckStatus(rawValue: rawStatus)
            } else {
                return nil
            }
        }

        set {
            self.rawStatus = newValue?.rawValue
        }
    }

    var imageURL: URL? {
        get {
            if let rawImageURL = self.rawImageURL {
                return URL(string: rawImageURL)
            } else {
                return nil
            }
        }

        set {
            self.rawImageURL = newValue?.absoluteString
        }
    }

    var creator: User? {
        get {
            return self.rawCreator
        }

        set {
            if let newValue = newValue as? DefaultUser {
                self.rawCreator = newValue
            } else {
                self.rawCreator = nil
            }
        }
    }
}
