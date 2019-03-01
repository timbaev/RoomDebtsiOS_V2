//
//  DefaultUserAccountExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultUserAccount: UserAccount {

    // MARK: - Instance Properties

    var avatarURL: URL? {
        get {
            if let rawAvatarURL = self.rawAvatarURL {
                return URL(string: rawAvatarURL)
            } else {
                return nil
            }
        }

        set {
            self.rawAvatarURL = newValue?.absoluteString
        }
    }
}
