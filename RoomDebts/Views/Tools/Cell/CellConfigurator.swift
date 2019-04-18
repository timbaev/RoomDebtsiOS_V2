//
//  CellConfigurator.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol CellConfigurator {

    // MARK: - Type Properties

    var reuseId: String { get }

    // MARK: - Instance Methods

    func configure(cell: UIView)
    func targetImageView(of cell: UIView) -> UIImageView?
}
