//
//  ProductList.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ProductList: AnyObject {

    // MARK: - Instance Properties

    var listType: ProductListType { get set }

    var count: Int { get }
    var isEmpty: Bool { get }

    var allProducts: [Product] { get }
    var users: [User] { get }

    // MARK: - Instance Subscripts

    subscript(index: Int) -> Product { get }

    // MARK: - Instance Methods

    func insert(product: Product, at index: Int)
    func removeProduct(at index: Int) -> Product

    func append(product: Product)
    func remove(product: Product)

    func append(user: User)

    func clearProducts()
    func clearUsers()
}
