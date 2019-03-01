//
//  UserService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol UserService {

    // MARK: - Instance Methods

    func search(keyword: String, success: @escaping ([User]) -> Void, failure: @escaping (WebError) -> Void)
}
