//
//  ConversationList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 01/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationList: AnyObject {

    // MARK: - Instance Properties

    var listType: ConversationListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var conversations: [Conversation] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Conversation { get }

    // MARK: - Instance Methods

    func insert(conversation: Conversation, at index: Int)
    func removeConversation(at index: Int) -> Conversation

    func append(conversation: Conversation)
    func remove(conversation: Conversation)

    func clearConversations()
}
