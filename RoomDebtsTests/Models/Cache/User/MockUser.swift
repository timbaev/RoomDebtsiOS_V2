//
//  MockUser.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockUser: User {

    // MARK: - Instance Properties

    var uid: Int64 = 0

    var firstName: String?
    var lastName: String?
    var imageURL: URL?
}
