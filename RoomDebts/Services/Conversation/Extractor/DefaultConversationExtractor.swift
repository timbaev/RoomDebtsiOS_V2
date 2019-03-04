//
//  DefaultConversationExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultConversationExtractor: ConversationExtractor {

    // MARK: - Instance Methods

    let conversationCoder: ConversationCoder

    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    func extractConversation(from json: [String: Any], cacheContext: CacheContext) throws -> Conversation {
        guard let conversationUID = self.conversationCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let conversation = cacheContext.conversationManager.firstOrNew(withUID: conversationUID)

        guard self.conversationCoder.decode(conversation: conversation, from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let creatorJSON = self.conversationCoder.creatorJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let opponentJSON = self.conversationCoder.opponentJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        let creator = try self.userExtractor.extractUser(from: creatorJSON, cacheContext: cacheContext)

        let opponent = try self.userExtractor.extractUser(from: opponentJSON, cacheContext: cacheContext)

        conversation.creator = creator
        conversation.opponent = opponent

        cacheContext.save()

        return conversation
    }

    func extractConversationList(from json: [[String: Any]], withListType listType: ConversationListType, cacheContext: CacheContext) throws -> ConversationList {
        let conversationList = cacheContext.conversationListManager.firstOrNew(withListType: listType)

        try json.forEach { conversationList.append(conversation: try self.extractConversation(from: $0, cacheContext: cacheContext)) }

        cacheContext.save()

        return conversationList
    }
}
