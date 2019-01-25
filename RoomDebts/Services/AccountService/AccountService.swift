//
//  AccountService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol AccountService {
 
    // MARK: - Instance Methods
    
    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> (), failure: @escaping (WebError) -> ())
    func confirm(phoneNumber: String, code: String, success: @escaping (UserAccount) -> (), failure: @escaping (WebError) -> ())
    func signIn(phoneNumber: String, success: @escaping () -> (), failure: @escaping (WebError) -> ())
}
