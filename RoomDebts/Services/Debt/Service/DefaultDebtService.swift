//
//  DefaultDebtService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 08/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultDebtService: DebtService {

    // MARK: - Instance Properties

    private let router = AuthRouter<DebtAPI>()

    // MARK: -

    let debtExtractor: DebtExtractor

    // MARK: - Instance Methods

    func create(with form: CreateDebtForm, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.create(form: form), success: { json in
            do {
                let debt = try self.debtExtractor.extractDebt(from: json, cacheContext: Services.cacheViewContext)

                success(debt)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                }
            }
        }, failure: failure)
    }
}
