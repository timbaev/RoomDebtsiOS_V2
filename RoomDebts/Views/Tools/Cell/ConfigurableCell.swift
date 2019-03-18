//
//  ConfigurableCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol ConfigurableCell {

    // MARK: - Associated Types

    associatedtype DataType

    // MARK: - Instance Methods

    func configure(data: DataType)
}
