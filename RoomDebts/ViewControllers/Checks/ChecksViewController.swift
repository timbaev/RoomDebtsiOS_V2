//
//  ChecksViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChecksViewController: LoggedViewController, ChecksViewDisplayLogic, ErrorMessagePresenter, NVActivityIndicatorViewable, EmptyStateViewable {

    // MARK: - Typealiases

    private typealias CheckCellConfiguarator = TableCellConfigurator<CheckTableViewCell, CheckViewModel>

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let checkCellIdentifier = "CheckCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    private var items: [CheckCellConfiguarator] = []

    // MARK: -

    var interactor: ChecksBusinessLogic!
    var router: ChecksRoutingLogic!

    // MARK: -

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.interactor.fetchChecks()
    }

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

    private func configureTableRefreshControl() {
        let tableRefreshControl = UIRefreshControl()

        tableRefreshControl.tintColor = Colors.white

        tableRefreshControl.addTarget(self,
                                      action: #selector(self.onTableRefreshControlRequested(_:)),
                                      for: .valueChanged)

        self.tableView.refreshControl = tableRefreshControl

        self.tableRefreshControl = tableRefreshControl
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

    func displayLoadingState(with title: String, message: String) {
        self.showLoadingState(with: title, message: message)
    }

    func displayEmptyState(with message: String, actionTitle action: String) {
        let action = EmptyStateAction(title: action, onClicked: { [unowned self] in
            self.router.showQRScanner()
        })

        self.showNoDataState(with: message, action: action)
    }

    func displayEmptyState(with image: UIImage, title: String, message: String, actionTitle: String) {
        let action = EmptyStateAction(title: actionTitle, onClicked: { [unowned self] in
            self.interactor.fetchChecks()
        })

        self.showEmptyState(image: image, title: title, message: message, action: action)
    }

    func displayChecks(with viewModels: [CheckViewModel]) {
        self.items = viewModels.map { CheckCellConfiguarator(item: $0) }

        self.tableView.reloadData()
    }

    func endRefreshing() {
        if self.tableRefreshControl.isRefreshing {
            self.tableRefreshControl.endRefreshing()
        }

        if self.isAnimating {
            self.stopAnimating()
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePlusBarButtonItem()
        self.configureTableRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.interactor.fetchChecks()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        self.router.prepare(for: segue, sender: sender)
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

// MARK: - UITableViewDataSource

extension ChecksViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.checkCellIdentifier, for: indexPath)

        self.items[indexPath.row].configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChecksViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let targetImageView = self.items[indexPath.row].targetImageView(of: cell) else {
            return
        }

        guard let imageURL = self.items[indexPath.row].item.imageURL else {
            return
        }

        ImageDownloader.shared.loadImage(for: imageURL, in: targetImageView)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.items.isEmpty else {
            return
        }

        guard let targetImageView = self.items[indexPath.row].targetImageView(of: cell) else {
            return
        }

        ImageDownloader.shared.cancelLoad(in: targetImageView)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router.showProducts(with: indexPath)
    }
}
