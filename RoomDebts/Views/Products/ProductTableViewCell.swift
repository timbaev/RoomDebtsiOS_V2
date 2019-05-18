//
//  ProductTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: -

    var datasource: ProductUsersCollectionDatasource?
}

// MARK: - ConfigurableCell

extension ProductTableViewCell: ConfigurableCell {

    // MARK: - Instance Methods

    func configure(data viewModel: ProductViewModel) {
        self.nameLabel.text = viewModel.name
        self.priceLabel.text = viewModel.price
        self.quantityLabel.text = viewModel.quantity

        self.datasource = ProductUsersCollectionDatasource(usersViewModel: viewModel.users)

        self.collectionView.dataSource = self.datasource
        self.collectionView.delegate = self.datasource
        self.collectionView.reloadData()
    }
}
