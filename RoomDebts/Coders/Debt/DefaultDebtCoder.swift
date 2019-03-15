//
//  DefaultDebtCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultDebtCoder: DebtCoder {

    // MARK: - Nested Types

    private enum JSONKeys {

        // MARK: - Type Properties

        static let price = "price"
        static let date = "date"
        static let description = "description"
        static let debtorID = "debtorID"
        static let conversationID = "conversationID"

        static let status = "status"
    }

    // MARK: - Instance Methods

    func encode(createForm form: CreateDebtForm) -> JSON {
        var requestParameters: [String: Any] = [:]

        requestParameters[JSONKeys.price] = form.price
        requestParameters[JSONKeys.date] = ISO8601Formatter.shared.string(from: form.date)
        requestParameters[JSONKeys.debtorID] = form.debtorUID
        requestParameters[JSONKeys.conversationID] = form.conversationUID

        if let description = form.description {
            requestParameters[JSONKeys.description] = description
        }

        return requestParameters
    }

    func encode(conversationUID: Int64) -> JSON {
        var requestParamters: JSON = [:]

        requestParamters[JSONKeys.conversationID] = conversationUID

        return requestParamters
    }

    func decode(debt: Debt, from json: JSON) -> Bool {
        guard let uid = self.uid(from: json) else {
            return false
        }

        guard let price: Double = JSONKeys.price <~~ json else {
            return false
        }

        guard let date = Gloss.Decoder.decode(dateISO8601ForKey: JSONKeys.date)(json) else {
            return false
        }

        guard let debtorUID: Int64 = JSONKeys.debtorID <~~ json else {
            return false
        }

        guard let rawStatus: String = JSONKeys.status <~~ json else {
            return false
        }

        guard let status = DebtStatus(rawValue: rawStatus) else {
            return false
        }

        let description: String? = JSONKeys.description <~~ json

        debt.uid = uid
        debt.price = price
        debt.date = date
        debt.debtorUID = debtorUID
        debt.status = status
        debt.debtDescription = description

        return true
    }
}
