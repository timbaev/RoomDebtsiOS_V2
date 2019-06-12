//
//  SectionHeaderTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 12/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: -

    var title: String? {
        get {
            return self.titleLabel.text
        }

        set {
            self.titleLabel.text = newValue
        }
    }
}
