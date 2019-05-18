//
//  CollectionCellConfigurator.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {

    // MARK: - Instance Properties

    var reuseId: String {
        return String(describing: CellType.self)
    }

    let item: DataType

    // MARK: - Initializers

    init(item: DataType) {
        self.item = item
    }

    // MARK: - Instance Methods

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: self.item)
    }

    func targetImageView(of cell: UIView) -> UIImageView? {
        return (cell as! CellType).targetImageView
    }
}
