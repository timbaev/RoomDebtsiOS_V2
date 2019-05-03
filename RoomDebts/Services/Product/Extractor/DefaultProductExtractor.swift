//
//  DefaultProductExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultProductExtractor: ProductExtractor {

    // MARK: - Instance Properties

    let productCoder: ProductCoder

    let userExtractor: UserExtractor

    // MARK: - Instance Methods

    private func extractProduct(from json: JSON, cacheContext: CacheContext) throws -> Product {
        guard let productUID = self.productCoder.uid(from: json) else {
            throw WebError(code: .badResponse)
        }

        let product = cacheContext.productManager.firstOrNew(withUID: productUID)

        guard self.productCoder.decode(product: product, from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let selectedUsersJSON = self.productCoder.selectedUsersJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        product.selectedUsers = try selectedUsersJSON.map {
            try self.userExtractor.extractUser(from: $0, cacheContext: cacheContext)
        }

        cacheContext.save()

        return product
    }

    // MARK: -

    func extractProductList(from json: JSON, withListType listType: ProductListType, cacheContext: CacheContext) throws -> ProductList {
        let productList = cacheContext.productListManager.firstOrNew(withListType: listType)

        productList.clearProducts()
        productList.clearUsers()

        guard let productsJSON = self.productCoder.productsJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        guard let usersJSON = self.productCoder.usersJSON(from: json) else {
            throw WebError(code: .badResponse)
        }

        try productsJSON.forEach {
            productList.append(product: try self.extractProduct(from: $0, cacheContext: cacheContext))
        }

        try usersJSON.forEach {
            productList.append(user: try self.userExtractor.extractUser(from: $0, cacheContext: cacheContext))
        }

        cacheContext.save()

        return productList
    }
}
