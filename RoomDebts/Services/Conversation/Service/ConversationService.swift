//
//  ConversationService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConversationService {

    // MARK: - Instance Methods

    func create(opponentUID: Int64, success: @escaping (Conversation) -> Void, failure: @escaping (WebError) -> Void)
    func fetch(success: @escaping (ConversationList) -> Void, failure: @escaping (WebError) -> Void)

    func accept(conversationUID: Int64, success: @escaping (Conversation) -> Void, failure: @escaping (WebError) -> Void)
    func reject(conversationUID: Int64, success: @escaping () -> Void, failure: @escaping (WebError) -> Void)
}
