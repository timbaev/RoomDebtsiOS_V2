//
//  DebtsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 04/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DebtsTableViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter, NVActivityIndicatorViewable {

    // MARK: - Type Aliases

    private typealias DebtCellConfigurator = TableCellConfigurator<DebtTableViewCell, DebtTableViewModel>

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showCreateDebt = "ShowCreateDebt"
        static let unauthorized = "Unauthorized"
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

    private var items: [CellConfigurator] = []

    // MARK: -

    private(set) var debtList: DebtList!
    private(set) var debtListType: DebtListType = .unknown

    private(set) var isRefreshingData = false
    private(set) var shouldApplyData = true

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromDebtsEvents()
        self.unsubscribeFromUserAccountEvents()
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

        case .unauthorized:
            self.performSegue(withIdentifier: Segues.unauthorized, sender: self)

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

    private func subscribeToUserAccountEvents() {
        self.unsubscribeFromUserAccountEvents()

        let userAccountManager = Services.cacheViewContext.userAccountManager

        userAccountManager.objectsChangedEvent.connect(self, handler: { [weak self] _ in
            self?.shouldApplyData = true
        })

        userAccountManager.startObserving()
    }

    private func unsubscribeFromUserAccountEvents() {
        Services.cacheViewContext.userAccountManager.objectsChangedEvent.disconnect(self)
    }

    // MARK: -

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

        plusBarButtonItem.tintColor = Colors.plusBarItem

        self.navigationItem.rightBarButtonItem = plusBarButtonItem
    }

    private func config(debtTableCell cell: DebtTableViewCell, at indexPath: IndexPath) {
        let debt = self.debtList[indexPath.row]

        guard let conversation = self.conversation else {
            return
        }

        let viewModel = DebtTableViewModel(debt: debt, conversation: conversation)

        TableCellConfigurator<DebtTableViewCell, DebtTableViewModel>(item: viewModel).configure(cell: cell)

        cell.onAcceptButtonClick = { [unowned self] in
            self.accept(debt: debt)
        }

        cell.onDeclineButtonClick = { [unowned self] in
            self.reject(debt: debt)
        }

        cell.onEditButtonClick = { [unowned self] in
            guard let conversation = self.conversation else {
                return
            }

            self.performSegue(withIdentifier: Segues.showCreateDebt, sender: (debt: debt, conversation: conversation))
        }

        cell.onDeleteButtonClick = { [unowned self] in
            let message: String
            let actionTitle: String

            if debt.status == .newRequest {
                message = "Debt can be delete without opponent approve".localized()
                actionTitle = "Delete".localized()
            } else {
                message = "Opponent should approve deletion of this debt".localized()
                actionTitle = "Send delete request".localized()
            }

            UIAlertController.Builder()
                .preferredStyle(.actionSheet)
                .withTitle("Deletion".localized())
                .withMessage(message)
                .addDestructiveAction(withTitle: actionTitle, handler: { [unowned self] action in
                    self.delete(debt: debt)
                })
                .addCancelAction()
                .show(in: self)
        }

        cell.onRepayButtonClick = { [unowned self] in
            UIAlertController.Builder()
                .preferredStyle(.actionSheet)
                .withTitle("Repay".localized())
                .withMessage("Opponent should approve repayment of this debt".localized())
                .addDefaultAction(withTitle: "Send repay request".localized(), handler: { [unowned self] action in
                    self.repayRequest(for: debt)
                })
                .addCancelAction()
                .show(in: self)
        }
    }

    // MARK: -

    private func refreshDebtList() {
        Log.i()

        guard let conversation = self.conversation else {
            return
        }

        self.isRefreshingData = true

        if self.isAnimating {
            self.stopAnimating()
        }

        if !self.tableRefreshControl.isRefreshing {
            if (self.debtList.isEmpty) || (!self.emptyStateContainerView.isHidden) {
                self.showLoadingState(with: "Loading debts".localized(),
                                      message: "We are loading list of debts. Please wait a bit".localized())
            }
        }

        Services.debtService.fetch(for: conversation.uid, success: { [weak self] debtList in
            self?.apply(debtList: debtList)
        }, failure: { [weak self] error in
            self?.handle(stateError: error, retryHandler: { [weak self] in
                self?.refreshDebtList()
            })
        })
    }

    private func accept(debt: Debt) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.debtService.accept(for: debt.uid, success: { [weak self] debt in
            self?.refreshDebtList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func reject(debt: Debt) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.debtService.reject(for: debt.uid, success: { [weak self] in
            self?.refreshDebtList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func delete(debt: Debt) {
        self.startAnimating(type: .ballScaleMultiple)

        if debt.status == .newRequest {
            Services.debtService.delete(debtUID: debt.uid, success: { [weak self] in
                self?.refreshDebtList()
            }, failure: { [weak self] error in
                guard let viewController = self else {
                    return
                }

                viewController.stopAnimating()
                viewController.handle(stateError: error)
            })
        } else {
            Services.debtService.deleteRequest(for: debt.uid, success: { [weak self] debt in
                self?.refreshDebtList()
            }, failure: { [weak self] error in
                guard let viewController = self else {
                    return
                }

                viewController.stopAnimating()
                viewController.handle(stateError: error)
            })
        }
    }

    private func repayRequest(for debt: Debt) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.debtService.repayRequest(for: debt.uid, success: { [weak self] debt in
            self?.refreshDebtList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    // MARK: -

    private func apply(debtList: DebtList, canShowState: Bool = true) {
        Log.i(debtList.count)

        self.debtList = debtList

        if debtList.isEmpty && canShowState {
            let action = EmptyStateAction(title: "Create new debt".localized(), onClicked: { [unowned self] in
                guard let conversation = self.conversation else {
                    return
                }

                self.performSegue(withIdentifier: Segues.showCreateDebt, sender: conversation)
            })

            self.showNoDataState(with: "Debts not exists".localized(), action: action)
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
        self.subscribeToUserAccountEvents()
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
            var dictionary: [String: Any] = [:]

            if let data = sender as? (debt: Debt, conversation: Conversation) {
                dictionary["debt"] = data.debt
                dictionary["conversation"] = data.conversation
            } else if let conversation = sender as? Conversation {
                dictionary["conversation"] = conversation
            } else {
                fatalError()
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: dictionary)
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
