//
//  DebtService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol DebtService {

    // MARK: - Instance Properties

    func create(with form: CreateDebtForm, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void)
    func fetch(for conversationUID: Int64, success: @escaping (DebtList) -> Void, failure: @escaping (WebError) -> Void)
}
