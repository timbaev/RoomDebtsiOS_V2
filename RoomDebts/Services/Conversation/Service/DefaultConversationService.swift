//
//  DefaultConversationService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 26/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultConversationService: ConversationService {

    // MARK: - Instance Properties

    private let router = AuthRouter<ConversationAPI>()

    let conversationExtractor: ConversationExtractor

    // MARK: - Instance Methods

    func create(opponentUID: Int64, success: @escaping (Conversation) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.create(opponentUID: opponentUID), success: { json in
            do {
                let conversation = try self.conversationExtractor.extractConversation(from: json, cacheContext: Services.cacheViewContext)

                success(conversation)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }

    func fetch(success: @escaping (ConversationList) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonArray(.fetch, success: { json in
            do {
                let conversationList = try self.conversationExtractor.extractConversationList(from: json, withListType: .all, cacheContext: Services.cacheViewContext)

                success(conversationList)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }

    func accept(conversationUID: Int64, success: @escaping (Conversation) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.accept(conversationUID: conversationUID), success: { json in
            do {
                let conversation = try self.conversationExtractor.extractConversation(from: json, cacheContext: Services.cacheViewContext)

                success(conversation)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }

    func reject(conversationUID: Int64, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.json(.reject(conversationUID: conversationUID), success: { object in
            Services.cacheViewContext.conversationManager.clear(withUID: conversationUID)

            success()
        }, failure: failure)
    }
}
