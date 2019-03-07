//
//  PriceTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var currencyView: CurrencyView!

    // MARK: -

    var price: String? {
        get {
            return self.currencyView.text
        }

        set {
            self.currencyView.text = newValue
        }
    }
}
