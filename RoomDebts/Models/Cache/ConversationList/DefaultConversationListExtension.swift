//
//  DefaultConversationListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultConversationList: ConversationList {

    // MARK: - Instance Properties

    var listType: ConversationListType {
        get {
            return ConversationListType(rawValue: self.listRawType) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
        }
    }

    var count: Int {
        return self.rawConversations?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawConversations?.count ?? 0) == 0)
    }

    var conversations: [Conversation] {
        return (self.rawConversations?.array as? [Conversation]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Conversation {
        return self.rawConversations![index] as! Conversation
    }

    // MARK: - Instance Methods

    func insert(conversation: Conversation, at index: Int) {
        if let conversation = conversation as? DefaultConversation {
            self.insertIntoRawConversations(conversation, at: index)
        }
    }

    func removeConversation(at index: Int) -> Conversation {
        let conversation = self.rawConversations![index] as! Conversation

        self.removeFromRawConversations(at: index)

        return conversation
    }

    func append(conversation: Conversation) {
        if let conversation = conversation as? DefaultConversation {
            self.addToRawConversations(conversation)
        }
    }

    func remove(conversation: Conversation) {
        if let conversation = conversation as? DefaultConversation {
            self.removeFromRawConversations(conversation)
        }
    }

    func clearConversations() {
        if let conversations = self.rawConversations {
            self.removeFromRawConversations(conversations)
        }
    }
}
