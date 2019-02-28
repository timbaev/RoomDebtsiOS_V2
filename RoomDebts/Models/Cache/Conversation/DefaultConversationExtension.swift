//
//  DefaultConversationExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 27/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultConversation: Conversation {

    // MARK: - Instance Properties

    var status: ConversationStatus? {
        get {
            if let rawStatus = self.rawStatus {
                return ConversationStatus(rawValue: rawStatus)
            } else {
                return nil
            }
        }

        set {
            self.rawStatus = status?.rawValue
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

    var opponent: User? {
        get {
            return self.rawOpponent
        }

        set {
            if let newValue = newValue as? DefaultUser {
                self.rawOpponent = newValue
            } else {
                self.rawOpponent = nil
            }
        }
    }
}
