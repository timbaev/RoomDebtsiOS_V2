//
//  DefaultCheckService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import PromiseKit

struct DefaultCheckService: CheckService {

    // MARK: - Instance Properties

    private let router = AuthRouter<CheckAPI>()

    let checkExtractor: CheckExtractor
    let productExtractor: ProductExtractor
    let checkUserExtractor: CheckUserExtractor

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm) -> Promise<Check> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.create(form: form), success: { response in
                firstly {
                    self.checkExtractor.extractCheck(from: response.content)
                }.done { check in
                    seal.fulfill(check)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func fetchAll() -> Promise<CheckList> {
        return Promise(resolver: { seal in
            self.router.jsonArray(.fetchAll, success: { response in
                firstly {
                    self.checkExtractor.extractCheckList(from: response.content, withListType: .all)
                }.done { checkList in
                    seal.fulfill(checkList)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func update(storeName store: String, for checkUID: Int64) -> Promise<Check> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.update(store: store, checkUID: checkUID), success: { response in
                firstly {
                    self.checkExtractor.extractCheck(from: response.content)
                }.done { check in
                    seal.fulfill(check)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func upload(image: UIImage, for checkUID: Int64) -> Promise<Check> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.upload(image: image.resized(), checkUID: checkUID), success: { response in
                firstly {
                    self.checkExtractor.extractCheck(from: response.content)
                }.done { check in
                    seal.fulfill(check)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
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

    func calculate(check checkUID: Int64, selectedProducts: [Product.UID: [User.UID]]) -> Promise<CheckUserList> {
        return Promise(resolver: { seal in
            var jsonSelectedProducts: [String: [User.UID]] = [:]

            selectedProducts.forEach { productUID, userUIDs in
                jsonSelectedProducts["\(productUID)"] = userUIDs
            }

            self.router.jsonArray(.calculate(selectedProducts: jsonSelectedProducts, checkUID: checkUID), success: { response in
                firstly {
                    self.checkUserExtractor.extractCheckUserList(from: response.content, withListType: .check(uid: checkUID))
                }.done { checkUserList in
                    seal.fulfill(checkUserList)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func fetchReviews(for checkUID: Int64) -> Promise<CheckUserList> {
        return Promise(resolver: { seal in
            self.router.jsonArray(.reviews(checkUID: checkUID), success: { response in
                firstly {
                    self.checkUserExtractor.extractCheckUserList(from: response.content, withListType: .check(uid: checkUID))
                }.done { checkUserList in
                    seal.fulfill(checkUserList)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func approve(for checkUID: Int64) -> Promise<CheckUserList> {
        return Promise(resolver: { seal in
            self.router.jsonArray(.approve(checkUID: checkUID), success: { response in
                firstly {
                    self.checkUserExtractor.extractCheckUserList(from: response.content, withListType: .check(uid: checkUID))
                }.done { checkUserList in
                    seal.fulfill(checkUserList)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func reject(for checkUID: Int64, message: String) -> Promise<CheckUserList> {
        return Promise(resolver: { seal in
            self.router.jsonArray(.reject(comment: message, checkUID: checkUID), success: { response in
                firstly {
                    self.checkUserExtractor.extractCheckUserList(from: response.content, withListType: .check(uid: checkUID))
                }.done { checkUserList in
                    seal.fulfill(checkUserList)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func fetch(check uid: Int64) -> Promise<Check> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.fetch(checkUID: uid), success: { response in
                firstly {
                    self.checkExtractor.extractCheck(from: response.content)
                }.done { check in
                    seal.fulfill(check)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }

    func distribute(check uid: Int64) -> Promise<Check> {
        return Promise(resolver: { seal in
            self.router.jsonObject(.distribute(checkUID: uid), success: { response in
                firstly {
                    self.checkExtractor.extractCheck(from: response.content)
                }.done { check in
                    seal.fulfill(check)
                }.catch { error in
                    seal.reject(error)
                }
            }, failure: { error in
                seal.reject(error)
            })
        })
    }
}
