//
//  ChekcService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import PromiseKit

protocol CheckService {

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm) -> Promise<Check>
    func fetchAll() -> Promise<CheckList>
    func update(storeName store: String, for checkUID: Int64) -> Promise<Check>
    func upload(image: UIImage, for checkUID: Int64) -> Promise<Check>

    func addParticipants(userUIDs: [Int64], for check: Check, response: @escaping (Swift.Result<ProductList, WebError>) -> Void)
    func removeParticipant(userUID: Int64, for check: Check, response: @escaping (Swift.Result<ProductList, WebError>) -> Void)

    func calculate(check checkUID: Int64, selectedProducts: [Product.UID: [User.UID]]) -> Promise<CheckUserList>
    func fetchReviews(for checkUID: Int64) -> Promise<CheckUserList>

    func approve(for checkUID: Int64) -> Promise<CheckUserList>
    func reject(for checkUID: Int64, message: String) -> Promise<CheckUserList>

    func fetch(check uid: Int64) -> Promise<Check>
    func distribute(check uid: Int64) -> Promise<Check>
}
