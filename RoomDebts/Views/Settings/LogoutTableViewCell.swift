//
//  LogoutTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var logOutlabel: UILabel!
}

// MARK: - ConfigurableCell

extension LogoutTableViewCell: ConfigurableCell {

    // MARK: - Instance Methods

    func configure(data viewModel: LogoutTableViewModel) {
        self.logOutlabel.text = viewModel.logout
    }
}
