//
//  SettingsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class SettingsTableViewController: LoggedViewController {

    // MARK: - Type Aliases

    private typealias SettingCellConfigurator = TableCellConfigurator<SettingTableViewCell, SettingTableViewModel>
    private typealias LogoutCellConfigurator = TableCellConfigurator<LogoutTableViewCell, LogoutTableViewModel>

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let numberRows = 3

        static let accountRowIndex = 0
        static let notificationsRowIndex = 1
        static let logoutRowIndex = 2
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showEditAccount = "ShowEditAccount"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var appVersionLabel: UILabel!

    // MARK: -

    let items: [CellConfigurator] = [
        SettingCellConfigurator(item: SettingTableViewModel(icon: #imageLiteral(resourceName: "MyAccountIcon.pdf"), title: "My Account".localized())),
        SettingCellConfigurator(item: SettingTableViewModel(icon: #imageLiteral(resourceName: "NotificationsIcon.pdf"), title: "Notifications".localized())),
        LogoutCellConfigurator(item: LogoutTableViewModel(logout: "Log Out".localized()))
    ]

    // MARK: - Instance Methods

    private func configAppVersion() {
        guard let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return
        }

        guard let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return
        }

        self.appVersionLabel.text = String(format: "App Version %@ (%@)".localized(), appVersion, buildNumber)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configAppVersion()
    }
}

// MARK: - UITableViewDataSource

extension SettingsTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId, for: indexPath)
        item.configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsTableViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case Constants.accountRowIndex:
            self.performSegue(withIdentifier: Segues.showEditAccount, sender: self)

        default:
            break
        }
    }
}
