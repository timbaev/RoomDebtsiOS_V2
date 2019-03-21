//
//  AccountService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol AccountService {

    // MARK: - Instance Methods

    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void)
    func confirm(phoneNumber: String, code: String, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void)
    func signIn(phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void)
    func uploadAvatar(image: UIImage, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void)
}
