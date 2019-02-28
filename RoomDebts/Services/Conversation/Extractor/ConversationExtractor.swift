//
//  ConversationExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationExtractor {

    // MARK: - Instance Methods

    func extractConversation(from json: [String: Any], cacheContext: CacheContext) throws -> Conversation
}
