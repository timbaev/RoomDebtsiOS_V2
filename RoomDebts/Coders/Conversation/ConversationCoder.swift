//
//  ConversationCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationCoder: Coder {

    // MARK: - Instance Methods

    func encode(opponentUID: Int64) -> [String: Any]

    func decode(conversation: Conversation, from json: [String: Any]) -> Bool

    func creatorJSON(from json: [String: Any]) -> [String: Any]?
    func opponentJSON(from json: [String: Any]) -> [String: Any]?
}
