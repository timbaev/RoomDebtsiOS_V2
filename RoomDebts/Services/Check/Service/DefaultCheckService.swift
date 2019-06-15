//
//  DefaultCheckService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

struct DefaultCheckService: CheckService {

    // MARK: - Instance Properties

    private let router = AuthRouter<CheckAPI>()

    let checkExtractor: CheckExtractor
    let productExtractor: ProductExtractor
    let checkUserExtractor: CheckUserExtractor

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm, success: @escaping (Check) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.create(form: form), success: { response in
            do {
                let check = try self.checkExtractor.extractCheck(from: response.content, cacheContext: Services.cacheViewContext)

                success(check)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }

    func fetch(success: @escaping (CheckList) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonArray(.fetchAll, success: { response in
            do {
                let checkList = try self.checkExtractor.extractCheckList(from: response.content, withListType: .all, cacheContext: Services.cacheViewContext)

                success(checkList)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }

    func update(storeName store: String, for check: Check, result: @escaping (Swift.Result<Check, WebError>) -> Void) {
        self.router.jsonObject(.update(store: store, checkUID: check.uid), success: { response in
            do {
                let check = try self.checkExtractor.extractCheck(from: response.content, cacheContext: Services.cacheViewContext)

                result(.success(check))
            } catch {
                if let webError = error as? WebError {
                    result(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    result(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            result(.failure(error))
        })
    }

    func upload(image: UIImage, for check: Check, result: @escaping (Swift.Result<Check, WebError>) -> Void) {
        self.router.jsonObject(.upload(image: image.resized(), checkUID: check.uid), success: { response in
            do {
                let check = try self.checkExtractor.extractCheck(from: response.content, cacheContext: Services.cacheViewContext)

                result(.success(check))
            } catch {
                if let webError = error as? WebError {
                    result(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    result(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            result(.failure(error))
        })
    }

    func addParticipants(userUIDs: [Int64], for check: Check, response: @escaping (Swift.Result<ProductList, WebError>) -> Void) {
        self.router.jsonObject(.participants(userUIDs: userUIDs, checkUID: check.uid), success: { httpResponse in
            do {
                let productList = try self.productExtractor.extractProductList(from: httpResponse.content, withListType: .check(uid: check.uid), cacheContext: Services.cacheViewContext)

                response(.success(productList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func removeParticipant(userUID: Int64, for check: Check, response: @escaping (Swift.Result<ProductList, WebError>) -> Void) {
        self.router.jsonObject(.removeParticipant(userUID: userUID, checkUID: check.uid), success: { httpResponse in
            do {
                let productList = try self.productExtractor.extractProductList(from: httpResponse.content, withListType: .check(uid: check.uid), cacheContext: Services.cacheViewContext)

                response(.success(productList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func calculate(check checkUID: Int64, selectedProducts: [Product.UID: [User.UID]], response: @escaping (Swift.Result<CheckUserList, WebError>) -> Void) {
        var jsonSelectedProducts: [String: [User.UID]] = [:]

        selectedProducts.forEach { productUID, userUIDs in
            jsonSelectedProducts["\(productUID)"] = userUIDs
        }

        self.router.jsonArray(.calculate(selectedProducts: jsonSelectedProducts, checkUID: checkUID), success: { httpResponse in
            do {
                let checkUserList = try self.checkUserExtractor.extractCheckUserList(from: httpResponse.content, withListType: .check(uid: checkUID), cacheContext: Services.cacheViewContext)

                response(.success(checkUserList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func fetchReviews(for checkUID: Int64, response: @escaping (Swift.Result<CheckUserList, WebError>) -> Void) {
        self.router.jsonArray(.reviews(checkUID: checkUID), success: { httpResponse in
            do {
                let checkUserList = try self.checkUserExtractor.extractCheckUserList(from: httpResponse.content, withListType: .check(uid: checkUID), cacheContext: Services.cacheViewContext)

                response(.success(checkUserList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func approve(for checkUID: Int64, response: @escaping (Swift.Result<CheckUserList, WebError>) -> Void) {
        self.router.jsonArray(.approve(checkUID: checkUID), success: { httpResponse in
            do {
                let checkUserList = try self.checkUserExtractor.extractCheckUserList(from: httpResponse.content, withListType: .check(uid: checkUID), cacheContext: Services.cacheViewContext)

                response(.success(checkUserList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func reject(for checkUID: Int64, message: String, response: @escaping (Swift.Result<CheckUserList, WebError>) -> Void) {
        self.router.jsonArray(.reject(comment: message, checkUID: checkUID), success: { httpResponse in
            do {
                let checkUserList = try self.checkUserExtractor.extractCheckUserList(from: httpResponse.content, withListType: .check(uid: checkUID), cacheContext: Services.cacheViewContext)

                response(.success(checkUserList))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }

    func fetch(check uid: Int64, response: @escaping (Swift.Result<Check, WebError>) -> Void) {
        self.router.jsonObject(.fetch(checkUID: uid), success: { httpResponse in
            do {
                let check = try self.checkExtractor.extractCheck(from: httpResponse.content, cacheContext: Services.cacheViewContext)

                response(.success(check))
            } catch {
                if let webError = error as? WebError {
                    response(.failure(webError))
                } else {
                    Log.e(error.localizedDescription)
                    response(.failure(WebError.unknown))
                }
            }
        }, failure: { error in
            response(.failure(error))
        })
    }
}
