//
//  ConversationTableViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ConversationTableViewModel {

    // MARK: - Instance Properties

    private let conversation: Conversation

    // MARK: -

    var isUserCreator: Bool {
        return self.conversation.creator?.uid == Services.userAccount?.uid
    }

    var isUserDebtor: Bool {
        return self.conversation.debtorUID == Services.userAccount?.uid
    }

    var opponent: User? {
        return self.isUserCreator ? self.conversation.opponent : self.conversation.creator
    }

    // MARK: -

    var avatar = #imageLiteral(resourceName: "AvatarPlaceholder.pdf")
    var opponentName: String?
    var status: String?
    var rejectStatus: String?
    var price: String?
    var priceTextColor = Colors.gray
    var isMoreButtonHidden = false
    var isVisited = false
    var isShowActions = false
    var isBadgeCountHidden = false
    var badgeCount: String?

    // MARK: - Initializers

    init(conversation: Conversation) {
        self.conversation = conversation

        self.configOpponentName()
        self.configStatus()
        self.configRejectStatus()
        self.configPrice()
        self.configVisited()
        self.configBadgeCount()
    }

    // MARK: - Instance Methods

    private func configOpponentName() {
        if let firstName = self.opponent?.firstName, let lastName = self.opponent?.lastName {
            self.opponentName = "\(firstName) \(lastName)"
        } else {
            self.opponentName = nil
        }
    }

    private func configStatus() {
        switch self.conversation.status {
        case .accepted?:
            self.isShowActions = false

            if conversation.price > 0 {
                if self.isUserDebtor {
                    self.status = "Repay".localized()
                    self.priceTextColor = Colors.red
                } else {
                    self.status = "Get".localized()
                    self.priceTextColor = Colors.green
                }
            } else {
                self.status = "No debts".localized()
                self.priceTextColor = Colors.gray
            }

        case .invited?, .repayRequest?, .deleteRequest?:
            self.status = conversation.status?.description(userIsCreator: self.isUserCreator)
            self.isShowActions = !self.isUserCreator
            self.isMoreButtonHidden = (!isUserCreator && conversation.status == .repayRequest)

        case nil:
            self.status = nil
            self.isShowActions = false
        }
    }

    private func configRejectStatus() {
        switch self.conversation.rejectStatus {
        case .accepted?, nil:
            self.rejectStatus = nil

        case .invited?:
            self.rejectStatus = "(Invite rejected)".localized()

        case .repayRequest?:
            self.rejectStatus = "(Repay all debts request rejected)".localized()

        case .deleteRequest?:
            self.rejectStatus = "(Delete request rejected)".localized()
        }
    }

    private func configPrice() {
        self.price = String(format: "%.2f₽", self.conversation.price)
    }

    private func configVisited() {
        self.isVisited = (self.conversation.newDebtCount == 0)
    }

    private func configBadgeCount() {
        self.isBadgeCountHidden = (self.conversation.newDebtCount == 0)
        self.badgeCount = "\(self.conversation.newDebtCount)"
    }
}
