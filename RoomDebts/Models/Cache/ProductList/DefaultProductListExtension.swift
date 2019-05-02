//
//  DefaultProductListExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

extension DefaultProductList: ProductList {

    // MARK: - Instance Properties

    var listType: ProductListType {
        get {
            return ProductListType(rawValue: self.listRawType, checkUID: self.checkUID) ?? .unknown
        }

        set {
            self.listRawType = newValue.rawValue
            self.checkUID = newValue.checkUID
        }
    }

    var count: Int {
        return self.rawProducts?.count ?? 0
    }

    var isEmpty: Bool {
        return ((self.rawProducts?.count ?? 0) == 0)
    }

    var allProducts: [Product] {
        return (self.rawProducts?.array as? [Product]) ?? []
    }

    var users: [User] {
        return (self.rawUsers?.array as? [User]) ?? []
    }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Product {
        return self.rawProducts![index] as! Product
    }

    // MARK: - Instance Methods

    func insert(product: Product, at index: Int) {
        if let product = product as? DefaultProduct {
            self.insertIntoRawProducts(product, at: index)
        }
    }

    func removeProduct(at index: Int) -> Product {
        let product = self.rawProducts![index] as! Product

        self.removeFromRawProducts(at: index)

        return product
    }

    func append(product: Product) {
        if let product = product as? DefaultProduct {
            self.addToRawProducts(product)
        }
    }

    func remove(product: Product) {
        if let product = product as? DefaultProduct {
            self.removeFromRawProducts(product)
        }
    }

    func append(user: User) {
        if let user = user as? DefaultUser {
            self.addToRawUsers(user)
        }
    }

    func clearProducts() {
        if let products = self.rawProducts {
            self.removeFromRawProducts(products)
        }
    }

    func clearUsers() {
        if let users = self.rawUsers {
            self.removeFromRawUsers(users)
        }
    }
}
