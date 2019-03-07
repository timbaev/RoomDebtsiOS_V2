//
//  DateTableViewCell.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 06/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    // MARK: - Instance Properties

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dateTextField: UITextField!

    // MARK: -

    var date: String? {
        get {
            return self.dateTextField.text
        }

        set {
            self.dateTextField.text = newValue
        }
    }

    // MARK: - Instance Methods

    @objc private func datePickerDidChange(_ sender: UIDatePicker) {
        self.dateTextField.text = DebtDateFormatter.shared.string(from: sender.date)
    }

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        let datePickerView = UIDatePicker()

        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(self.datePickerDidChange(_:)), for: .valueChanged)

        self.dateTextField.inputView = datePickerView
    }
}
