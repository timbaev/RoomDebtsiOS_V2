//
//  DefaultConversationVisitCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultConversationVisitCoder: ConversationVisitCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let userID = "userID"
        static let conversationID = "conversationID"
        static let visitDate = "visitDate"
    }

    // MARK: - Instance Methods

    func decode(conversationVisit: ConversationVisit, from json: [String: Any]) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let userUID: Int64 = JSONKeys.userID <~~ json else {
            return false
        }

        guard let conversationUID: Int64 = JSONKeys.conversationID <~~ json else {
            return false
        }

        guard let visitDate = Gloss.Decoder.decode(dateISO8601ForKey: JSONKeys.visitDate)(json) else {
            return false
        }

        conversationVisit.uid = uid

        conversationVisit.userUID = userUID
        conversationVisit.conversationUID = conversationUID
        conversationVisit.visitDate = visitDate

        return true
    }
}
