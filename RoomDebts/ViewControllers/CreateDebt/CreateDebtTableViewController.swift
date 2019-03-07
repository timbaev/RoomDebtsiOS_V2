//
//  CreateDebtTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class CreateDebtTableViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let numberOfRows = 4

        static let priceCellIdentifier = "PriceCell"
        static let dateCellIdentifier = "DateCell"
        static let descriptionCellIdentifier = "DescriptionCell"
        static let debtorCellIdentifier = "DebtorCell"

        static let priceCellRow = 0
        static let dateCellRow = 1
        static let descriptionCellRow = 2
        static let debtorCellRow = 3

        static let decimalSeparator = "."
        static let maxFractionDigits = 2
        static let currencySymbol = "₽"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var createButton: PrimaryButton!

    // MARK: -

    private var conversation: Conversation?

    // MARK: - Instance Methods

    @IBAction private func onCancelButtonTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        self.dismiss(animated: true)
    }

    // MARK: -

    private func apply(conversation: Conversation) {
        Log.i(conversation.uid)

        self.conversation = conversation
    }

    // MARK: -

    private func config(priceTableCell cell: PriceTableViewCell) { }

    private func config(debtorTableCell cell: DebtorTableViewCell) {
        guard let conversation = self.conversation else {
            return
        }

        if let creatorName = conversation.creator?.firstName {
            cell.creatorName = creatorName
        } else {
            cell.creatorName = nil
        }

        if let opponentName = conversation.opponent?.firstName {
            cell.opponentName = opponentName
        } else {
            cell.opponentName = nil
        }
    }
}

// MARK: - UITableViewDataSource

extension CreateDebtTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        switch indexPath.row {
        case Constants.priceCellRow:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.priceCellIdentifier, for: indexPath)

            self.config(priceTableCell: cell as! PriceTableViewCell)

        case Constants.dateCellRow:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.dateCellIdentifier, for: indexPath)

        case Constants.descriptionCellRow:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.descriptionCellIdentifier, for: indexPath)

        case Constants.debtorCellRow:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.debtorCellIdentifier, for: indexPath)

            self.config(debtorTableCell: cell as! DebtorTableViewCell)

        default:
            fatalError()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateDebtTableViewController: UITableViewDelegate { }

// MARK: - DictionaryReceiver

extension CreateDebtTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let conversation = dictionary["conversation"] as? Conversation else {
            return
        }

        self.apply(conversation: conversation)
    }
}
