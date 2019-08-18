//
//  ConversationVisitCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/08/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationVisitCoder: Coder {

    // MARK: - Instance Methods

    func decode(conversationVisit: ConversationVisit, from json: [String: Any]) -> Bool
}
