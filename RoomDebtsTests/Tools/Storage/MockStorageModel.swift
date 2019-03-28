//
//  MockStorageModel.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 28/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
@testable import RoomDebts

class MockStorageModel: StorageModel {

    // MARK: - Instance Properties

    var identifier: String

    // MARK: -

    public private(set) lazy var viewContext: StorageContext = { [unowned self] in
        return MockStorageContext(model: self, parent: nil)
    }()

    // MARK: - Initializers

    required init(identifier: String) {
        self.identifier = identifier
    }
}
