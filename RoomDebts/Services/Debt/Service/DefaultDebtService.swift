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
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }

    func fetch(for conversationUID: Int64, success: @escaping (DebtList) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonArray(.fetch(conversationUID: conversationUID), success: { json in
            do {
                let debtList = try self.debtExtractor.extractDebtList(from: json, withListType: .conversation(uid: conversationUID), cacheContext: Services.cacheViewContext)

                success(debtList)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }

    func accept(for debtUID: Int64, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.accept(debtUID: debtUID), success: { json in
            do {
                let debt = try self.debtExtractor.extractDebt(from: json, cacheContext: Services.cacheViewContext)

                success(debt)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }

    func reject(for debtUID: Int64, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.json(.reject(debtUID: debtUID), success: {
            Services.cacheViewContext.debtManager.clear(withUID: debtUID)

            success()
        }, failure: failure)
    }

    func update(for debtUID: Int64, form: CreateDebtForm, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.update(debtUID: debtUID, form: form), success: { json in
            do {
                let debt = try self.debtExtractor.extractDebt(from: json, cacheContext: Services.cacheViewContext)

                success(debt)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }
}
