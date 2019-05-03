//
//  ProductService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ProductService {

    // MARK: - Instance Methods

    func fetch(with checkUID: Int64, result: @escaping (Swift.Result<ProductList, WebError>) -> Void)
}
