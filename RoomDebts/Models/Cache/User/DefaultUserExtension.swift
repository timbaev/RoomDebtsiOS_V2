//
//  DefaultUserExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultUser: User {

    // MARK: - Instance Properties

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
}
