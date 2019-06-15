//
//  DefaultProductService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultProductService: ProductService {

    // MARK: - Instance Properties

    private let router = AuthRouter<CheckAPI>()

    let productExtractor: ProductExtractor

    // MARK: - Instance Methods

    func fetch(with checkUID: Int64, result: @escaping (Swift.Result<ProductList, WebError>) -> Void) {
        self.router.jsonObject(.fetchProducts(uid: checkUID), success: { response in
            do {
                let productList = try self.productExtractor.extractProductList(from: response.content, withListType: .check(uid: checkUID), cacheContext: Services.cacheViewContext)

                result(.success(productList))
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
