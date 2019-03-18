//
//  DebtTableViewModel.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 18/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct DebtTableViewModel {

    // MARK: - Instance Properties

    let hasRequest: Bool
    let isButtonsHidden: Bool
    let request: String?
    let price: String?
    let priceTextColor: UIColor
    let debtor: String?
    let date: String?
    let debtDescription: String?
    let creator: String?
    let isToolbarHidden: Bool
    let isRepayButtonHidden: Bool

    // MARK: - Initializers

    // swiftlint:disable function_body_length
    init(debt: Debt, conversation: Conversation) {
        let userIsDebtor = (debt.debtorUID == Services.userAccount?.uid)
        let userIsCreator = (debt.creator?.uid == Services.userAccount?.uid)

        let userIsConversationCreator = (conversation.creator?.uid == Services.userAccount?.uid)
        let opponent = userIsConversationCreator ? conversation.opponent : conversation.creator

        switch debt.status {
        case .accepted?, nil:
            self.hasRequest = false
            self.isButtonsHidden = true
            self.isToolbarHidden = false
            self.request = nil
            self.isRepayButtonHidden = false

        case .newRequest?, .editRequest?, .closeRequest?, .deleteRequest?:
            self.hasRequest = true
            self.isRepayButtonHidden = true

            if userIsCreator {
                self.request = String(format: "Pending %@".localized(), debt.status?.description ?? "")
                self.isButtonsHidden = true
                self.isToolbarHidden = false
            } else {
                self.request = debt.status?.description
                self.isButtonsHidden = false
                self.isToolbarHidden = true
            }
        }

        self.price = String(format: "%.2f", debt.price)

        if let userFirstName = Services.userAccount?.firstName, let opponentFirstName = opponent?.firstName {
            if userIsDebtor {
                self.priceTextColor = Colors.red
                self.debtor = "\(opponentFirstName) -> \(userFirstName)"
            } else {
                self.priceTextColor = Colors.green
                self.debtor = "\(userFirstName) -> \(opponentFirstName)"
            }
        } else {
            self.debtor = nil
            self.priceTextColor = Colors.gray
        }

        if let date = debt.date {
            self.date = DebtDateFormatter.shared.string(from: date)
        } else {
            self.date = nil
        }

        self.debtDescription = debt.debtDescription

        if let firstName = debt.creator?.firstName, let lastName = debt.creator?.lastName {
            self.creator = "\(firstName) \(lastName)"
        } else {
            self.creator = nil
        }
    }
}
