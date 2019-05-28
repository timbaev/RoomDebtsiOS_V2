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
        self.router.jsonArray(.fetch, success: { response in
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
}
