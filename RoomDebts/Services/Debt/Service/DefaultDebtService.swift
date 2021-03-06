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
        self.router.jsonObject(.create(form: form), success: { response in
            do {
                let debt = try self.debtExtractor.extractDebt(from: response.content, cacheContext: Services.cacheViewContext)

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
        self.router.jsonArray(.fetch(conversationUID: conversationUID), success: { response in
            do {
                let debtList = try self.debtExtractor.extractDebtList(from: response.content, withListType: .conversation(uid: conversationUID), cacheContext: Services.cacheViewContext)

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

    func accept(for debtUID: Int64, success: @escaping (Debt?) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.json(.accept(debtUID: debtUID), success: { response in
            guard let json = response.content as? JSON else {
                return success(nil)
            }

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
        self.router.json(.reject(debtUID: debtUID), success: { response in
            success()
        }, failure: failure)
    }

    func update(for debtUID: Int64, form: CreateDebtForm, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.update(debtUID: debtUID, form: form), success: { response in
            do {
                let debt = try self.debtExtractor.extractDebt(from: response.content, cacheContext: Services.cacheViewContext)

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

    func deleteRequest(for debtUID: Int64, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.deleteRequest(debtUID: debtUID), success: { response in
            do {
                let debt = try self.debtExtractor.extractDebt(from: response.content, cacheContext: Services.cacheViewContext)

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

    func delete(debtUID: Int64, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.router.json(.delete(debtUID: debtUID), success: { response in
            Services.cacheViewContext.debtManager.clear(withUID: debtUID)

            success()
        }, failure: failure)
    }

    func repayRequest(for debtUID: Int64, success: @escaping (Debt) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.repayRequest(debtUID: debtUID), success: { response in
            do {
                let debt = try self.debtExtractor.extractDebt(from: response.content, cacheContext: Services.cacheViewContext)

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
