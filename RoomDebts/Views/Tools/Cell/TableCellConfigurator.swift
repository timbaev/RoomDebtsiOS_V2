//
//  TableCellConfigurator.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 17/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {

    // MARK: - Type Properties

    var reuseId: String {
        return String(describing: CellType.self)
    }

    // MARK: - Instance Properties

    let item: DataType

    // MARK: - Initializers

    init(item: DataType) {
        self.item = item
    }

    // MARK: - Instance Methods

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }

    func targetImageView(of cell: UIView) -> UIImageView? {
        return (cell as! CellType).targetImageView
    }
}
