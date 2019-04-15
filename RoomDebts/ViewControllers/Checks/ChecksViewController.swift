//
//  ChecksViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChecksViewController: LoggedViewController, ChecksViewDisplayLogic, ErrorMessagePresenter, NVActivityIndicatorViewable {

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    var interactor: ChecksBusinessLogic!
    var router: ChecksRoutingLogic!

    // MARK: - Instance Methods

    @objc private func onPlusButtonTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        self.router.showQRScanner()
    }

    @IBAction private func onScanningFinished(_ segue: UIStoryboardSegue) {
        Log.i(segue.identifier)
    }

    // MARK: -

    private func configurePlusBarButtonItem() {
        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPlusButtonTouchUpInside(_:)))

        plusBarButtonItem.tintColor = Colors.plusBarItem

        self.navigationItem.rightBarButtonItem = plusBarButtonItem
    }

    // MARK: - ChecksViewDisplayLogic

    func displayMessage(with error: WebError) {
        self.showMessage(withError: error)
    }

    func displayMessage(with title: String, message: String) {
        self.showMessage(withTitle: title, message: message)
    }

    func displayLoadingIndicator() {
        self.startAnimating(type: .ballScaleMultiple)
    }

    func hideLoadingIndicator() {
        self.stopAnimating()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePlusBarButtonItem()
    }
}

// MARK: - DictionaryReceiver

extension ChecksViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let metadata = dictionary["QRCodeMetadata"] as? String else {
            return
        }

        self.interactor.createCheck(with: metadata)
    }
}
