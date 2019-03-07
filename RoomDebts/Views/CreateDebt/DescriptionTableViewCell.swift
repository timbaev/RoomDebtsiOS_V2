//
//  DescriptionTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 06/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var descriptionTextView: PlaceholderTextView!

    // MARK: -

    var debtDescription: String? {
        get {
            return self.descriptionTextView.text
        }

        set {
            self.descriptionTextView.text = newValue
        }
    }
}
