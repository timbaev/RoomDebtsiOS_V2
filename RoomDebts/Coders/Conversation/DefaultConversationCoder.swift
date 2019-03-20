//
//  DefaultConversationCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultConversationCoder: ConversationCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let opponentID = "opponentID"

        static let debtorID = "debtorID"
        static let price = "price"
        static let status = "status"
        static let rejectStatus = "rejectStatus"

        static let creator = "creator"
        static let opponent = "opponent"
    }

    // MARK: - Instance Methods

    func encode(opponentUID: Int64) -> [String: Any] {
        var requestParameters: [String: Any] = [:]

        requestParameters[JSONKeys.opponentID] = opponentUID

        return requestParameters
    }

    func decode(conversation: Conversation, from json: [String: Any]) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let rawStatus: String = JSONKeys.status <~~ json else {
            return false
        }

        guard let status = ConversationStatus(rawValue: rawStatus) else {
            return false
        }

        guard let price: Double = JSONKeys.price <~~ json else {
            return false
        }

        let debtorUID: Int64 = JSONKeys.debtorID <~~ json ?? 0

        var rejectStatus: ConversationStatus?

        if let rawRejectStatus: String = JSONKeys.rejectStatus <~~ json {
            rejectStatus = ConversationStatus(rawValue: rawRejectStatus)
        }

        conversation.uid = uid

        conversation.debtorUID = debtorUID
        conversation.price = price
        conversation.status = status
        conversation.rejectStatus = rejectStatus

        return true
    }
}
