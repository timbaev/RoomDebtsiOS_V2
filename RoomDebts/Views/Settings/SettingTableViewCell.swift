//
//  SettingTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
}

// MARK: - ConfigurableCell

extension SettingTableViewCell: ConfigurableCell {

    // MARK: - Instance Methods

    func configure(data viewModel: SettingTableViewModel) {
        self.iconImageView.image = viewModel.icon
        self.titleLabel.text = viewModel.title
    }
}
