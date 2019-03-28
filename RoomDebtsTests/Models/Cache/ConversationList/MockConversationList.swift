//
//  MockConversationList.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockConversationList: ConversationList {

    // MARK: - Instance Properties

    var listType: ConversationListType = .unknown
    var count: Int = 0
    var isEmpty: Bool = false
    var conversations: [Conversation] = []

    // MARK: - Subscripts

    subscript(index: Int) -> Conversation {
        return MockConversation()
    }

    // MARK: - Instance Methods

    func insert(conversation: Conversation, at index: Int) {

    }

    func removeConversation(at index: Int) -> Conversation {
        return MockConversation()
    }

    func append(conversation: Conversation) {

    }

    func remove(conversation: Conversation) {

    }

    func clearConversations() {
        
    }
}
