//
//  DebtsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 04/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DebtsTableViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showCreateDebt = "ShowCreateDebt"
    }

    // MARK: -

    private enum Constants {

        // MARK: - Type Properties

        static let debtCellIdentifier = "DebtCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: -

    private var conversation: Conversation?

    // MARK: -

    private(set) var debtList: DebtList!
    private(set) var debtListType: DebtListType = .unknown

    private(set) var isRefreshingData = false
    private(set) var shouldApplyData = true

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromDebtsEvents()
    }

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshDebtList()
    }

    @objc private func onPlusButtonTouchUpInside(sender: UIBarButtonItem) {
        Log.i()

        guard let conversation = self.conversation else {
            return
        }

        self.performSegue(withIdentifier: Segues.showCreateDebt, sender: conversation)
    }

    // MARK: -

    private func handle(stateError error: WebError, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error {
        case .connection, .timeOut:
            if self.debtList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .badRequest:
            if let message = error.message {
                if self.debtList?.isEmpty ?? true {
                    self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                        title: Messages.unknownErrorTitle,
                                        message: message,
                                        action: action)
                } else {
                    self.showMessage(withTitle: nil, message: message)
                }
            } else {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: Messages.unknownErrorTitle,
                                    message: Messages.unknownError,
                                    action: action)
            }

        default:
            if self.debtList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: Messages.unknownErrorTitle,
                                    message: Messages.unknownError,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.unknownErrorTitle, message: Messages.unknownError)
            }
        }
    }

    // MARK: -

    private func subscribeToDebtsEvents() {
        self.unsubscribeFromDebtsEvents()

        let debtManager = Services.cacheViewContext.debtManager

        debtManager.objectsChangedEvent.connect(self, handler: { [weak self] _ in
            self?.shouldApplyData = true
        })

        debtManager.startObserving()
    }

    private func unsubscribeFromDebtsEvents() {
        Services.cacheViewContext.debtManager.objectsChangedEvent.disconnect(self)
    }

    // MARK: -

    private func configEmptyState() {
        self.emptyStateView.textColor = Colors.white
        self.emptyStateView.activityIndicatorColor = Colors.white
        self.emptyStateView.backgroundColor = Colors.emptyState
    }

    private func configTableRefreshControl() {
        let tableRefreshControl = UIRefreshControl()

        tableRefreshControl.tintColor = Colors.white

        tableRefreshControl.addTarget(self,
                                      action: #selector(self.onTableRefreshControlRequested(_:)),
                                      for: .valueChanged)

        self.tableView.refreshControl = tableRefreshControl
        self.tableRefreshControl = tableRefreshControl
    }

    private func configPlusBarButtonItem() {
        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPlusButtonTouchUpInside(sender:)))

        plusBarButtonItem.tintColor = Colors.barItem

        self.navigationItem.rightBarButtonItem = plusBarButtonItem
    }

    private func config(debtTableCell cell: DebtTableViewCell, at indexPath: IndexPath) {
        let debt = self.debtList[indexPath.row]

        let userIsDebtor = (debt.debtorUID == Services.userAccount?.uid)
        let userIsCreator = (debt.creator?.uid == Services.userAccount?.uid)

        switch debt.status {
        case .accepted?:
            cell.hasRequest = false

        case .newRequest?, .editRequest?, .closeRequest?, .deleteRequest?:
            cell.request = debt.status?.description
            cell.hasRequest = !userIsCreator

        case nil:
            cell.hasRequest = false
        }

        cell.price = String(format: "%.2f", debt.price)

        if userIsDebtor {
            cell.priceTextColor = Colors.red
        } else {
            cell.priceTextColor = Colors.green
        }

        if let date = debt.date {
            cell.date = DebtDateFormatter.shared.string(from: date)
        } else {
            cell.date = nil
        }

        cell.debtDescription = debt.debtDescription

        if let firstName = debt.creator?.firstName, let lastName = debt.creator?.lastName {
            cell.creator = "\(firstName) \(lastName)"
        } else {
            cell.creator = nil
        }

        cell.onAcceptButtonClick = { }

        cell.onDeclineButtonClick = { }
    }

    // MARK: -

    private func refreshDebtList() {
        Log.i()

        guard let conversation = self.conversation else {
            return
        }

        self.isRefreshingData = true

        if !self.tableRefreshControl.isRefreshing {
            if (self.debtList.isEmpty) || (!self.emptyStateContainerView.isHidden) {
                self.showLoadingState(with: "Loading debts".localized(),
                                      message: "We are loading list of debts. Please wait a bit".localized())
            }
        }

        Services.debtService.fetch(for: conversation.uid, success: { [weak self] debtList in
            guard let viewController = self else {
                return
            }

            viewController.apply(debtList: debtList)
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.handle(stateError: error, retryHandler: { [weak self] in
                self?.refreshDebtList()
            })
        })
    }

    // MARK: -

    private func apply(debtList: DebtList, canShowState: Bool = true) {
        Log.i(debtList.count)

        self.debtList = debtList

        if debtList.isEmpty && canShowState {
            self.showNoDataState(with: "Debts not exists".localized())
        } else {
            self.hideEmptyState()
        }

        if self.tableRefreshControl.isRefreshing {
            self.tableRefreshControl.endRefreshing()
        }

        self.isRefreshingData = false

        self.tableView.reloadData()

        self.shouldApplyData = false
    }

    private func apply(debtListType: DebtListType) {
        self.debtListType = debtListType

        if self.isViewLoaded {
            self.apply(debtList: Services.cacheViewContext.debtListManager.firstOrNew(withListType: debtListType), canShowState: false)

            self.refreshDebtList()

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(conversation: Conversation) {
        Log.i(conversation.uid)

        self.conversation = conversation

        if self.isViewLoaded {
            let userIsCreator = (conversation.creator?.uid == Services.userAccount?.uid)
            let opponent = userIsCreator ? conversation.opponent : conversation.creator

            if let firstName = opponent?.firstName, let lastName = opponent?.lastName {
                self.navigationItem.title = "\(firstName) \(lastName)"
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.configEmptyState()
        self.configTableRefreshControl()
        self.configPlusBarButtonItem()

        self.subscribeToDebtsEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let conversation = self.conversation {
            self.apply(conversation: conversation)
            self.apply(debtListType: .conversation(uid: conversation.uid))
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let dictionaryReceiver: DictionaryReceiver?

        if let navigationController = segue.destination as? UINavigationController {
            dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
        } else {
            dictionaryReceiver = segue.destination as? DictionaryReceiver
        }

        switch segue.identifier {
        case Segues.showCreateDebt:
            guard let conversation = sender as? Conversation else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["conversation": conversation])
            }

        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension DebtsTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.debtList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.debtCellIdentifier, for: indexPath)

        self.config(debtTableCell: cell as! DebtTableViewCell, at: indexPath)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension DebtsTableViewController: UITableViewDelegate { }

// MARK: - DictionaryReceiver

extension DebtsTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let conversation = dictionary["conversation"] as? Conversation else {
            return
        }

        self.apply(conversation: conversation)
    }
}
