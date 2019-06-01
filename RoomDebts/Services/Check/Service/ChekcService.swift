//
//  ChekcService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol CheckService {

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm, success: @escaping (Check) -> Void, failure: @escaping (WebError) -> Void)
    func fetch(success: @escaping (CheckList) -> Void, failure: @escaping (WebError) -> Void)
    func update(storeName store: String, for check: Check, result: @escaping (Swift.Result<Check, WebError>) -> Void)
    func upload(image: UIImage, for check: Check, result: @escaping (Swift.Result<Check, WebError>) -> Void)
    func addParticipants(userUIDs: [Int64], for check: Check, response: @escaping (Swift.Result<ProductList, WebError>) -> Void)
}
