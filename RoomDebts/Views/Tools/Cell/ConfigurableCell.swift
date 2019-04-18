//
//  ConfigurableCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol ConfigurableCell {

    // MARK: - Associated Types

    associatedtype DataType

    // MARK: - Instance Properties

    var targetImageView: UIImageView? { get }

    // MARK: - Instance Methods

    func configure(data: DataType)
}

// MARK: -

extension ConfigurableCell {

    // MARK: - Instance Properties

    var targetImageView: UIImageView? {
        return nil
    }
}
