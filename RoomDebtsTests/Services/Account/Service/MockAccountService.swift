//
//  MockAccountService.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 31/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
@testable import RoomDebts

class MockAccountService: AccountService {

    // MARK: - Instance Properties

    private(set) var createCalled = false

    // MARK: -

    var didCreateSuccess: (() -> Void)?

    // MARK: - Instance Methods

    func create(firstName: String, lastName: String, phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {
        self.createCalled = true

        success()
    }

    func confirm(phoneNumber: String, code: String, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void) {

    }

    func signIn(phoneNumber: String, success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {

    }

    func uploadAvatar(image: UIImage, success: @escaping (UserAccount) -> Void, failure: @escaping (WebError) -> Void) {

    }

    func update(firstName: String, lastName: String, phoneNumber: String, success: @escaping (UserAccount, Bool) -> Void, failure: @escaping (WebError) -> Void) {

    }

    func logout(success: @escaping () -> Void, failure: @escaping (WebError) -> Void) {

    }
}
