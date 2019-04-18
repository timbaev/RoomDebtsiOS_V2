//
//  ChekcService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CheckService {

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm, success: @escaping (Check) -> Void, failure: @escaping (WebError) -> Void)
    func fetch(success: @escaping (CheckList) -> Void, failure: @escaping (WebError) -> Void)
}
