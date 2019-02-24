//
//  DefaultUserService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultUserService: UserService {

    // MARK: - Instance Properties

    private var router = AuthRouter<UserAPI>()

    // MARK: - Instance Methods

    func search(keyword: String, success: @escaping () -> (), failure: @escaping (WebError) -> ()) {
        self.router.request(.search(keyword: keyword), success: { json in
            
        }, failure: failure)
    }
}
