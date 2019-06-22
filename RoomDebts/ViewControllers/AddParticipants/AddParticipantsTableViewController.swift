//
//  AddParticipantsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddParticipantsTableViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter, NVActivityIndicatorViewable {

    // MARK: - Typealiases

    private typealias AddParticipantCellConfigurator = TableCellConfigurator<AddParticipantTableViewCell, AddParticipantViewModel>

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let unauthorized = "Unauthorized"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    private var userList: UserList!
    private var userListType: UserListType = .unknown

    private var checkUsers: [User]?
    private var check: Check?

    private var selectedUsers: [User] = []

    private var items: [AddParticipantCellConfigurator] = []

    private var isRefreshingData = false
    private var shouldApplyData = true

    // MARK: -

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshUserList()
    }

    @IBAction private func onCancelBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        self.dismiss(animated: true)
    }

    @IBAction private func onDoneBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        let userUIDs = self.selectedUsers.map { $0.uid }

        self.addPrticipants(userUIDs: userUIDs)
    }

    // MARK: -

    private func updateDoneBarButtonItemState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.selectedUsers.isEmpty
    }

    // MARK: -

    private func handle(stateError error: WebError, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error {
        case .connection, .timeOut:
            if self.userList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .badRequest:
            if let message = error.message {
                if self.userList?.isEmpty ?? true {
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
            if self.userList?.isEmpty ?? true {
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

    private func subscribeToConversationsEvents() {
        self.unsubscribeFromConversationsEvents()

        let conversationManager = Services.cacheViewContext.conversationManager

        conversationManager.objectsChangedEvent.connect(self, handler: { [weak self] _ in
            self?.shouldApplyData = true
        })

        conversationManager.startObserving()
    }

    private func unsubscribeFromConversationsEvents() {
        Services.cacheViewContext.conversationManager.objectsChangedEvent.disconnect(self)
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

    // MARK: -

    private func refreshUserList() {
        Log.i()

        self.isRefreshingData = true

        if !self.tableRefreshControl.isRefreshing {
            if self.userList.isEmpty || !self.emptyStateContainerView.isHidden {
                self.showLoadingState(with: "Loading users".localized(),
                                      message: "We are loading list of users. Please wait a bit".localized())
            }
        }

        Services.userService.fetchInviteList(response: { [weak self] result in
            guard let viewController = self else {
                return
            }

            switch result {
            case .success(let userList):
                viewController.apply(userList: userList)

            case .failure(let error):
                viewController.handle(stateError: error, retryHandler: { [weak self] in
                    self?.refreshUserList()
                })
            }
        })
    }

    private func addPrticipants(userUIDs: [Int64]) {
        guard let check = self.check else {
            return
        }

        self.startAnimating()

        Services.checkService.addParticipants(userUIDs: userUIDs, for: check, response: { [weak self] result in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            switch result {
            case .success:
                viewController.dismiss(animated: true)

            case .failure(let error):
                viewController.handle(stateError: error)
            }
        })
    }

    // MARK: -

    private func apply(userList: UserList, canShowState: Bool = true) {
        Log.i(userList.count)

        self.userList = userList

        if let checkUsers = self.checkUsers {
            self.items = userList.allUsers.map { user in
                let userIsCheck = checkUsers.contains { $0.uid == user.uid }

                let viewModel = AddParticipantViewModel(user: user, isEnabled: !userIsCheck)

                return AddParticipantCellConfigurator(item: viewModel)
            }
        }

        if userList.isEmpty && canShowState {
            let action = EmptyStateAction(title: "Create debt conversation".localized(), onClicked: { [unowned self] in
                self.tabBarController?.selectedIndex = Tabs.search.rawValue
            })

            self.showNoDataState(with: "You have not debt conversations with users".localized(), action: action)
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

    private func apply(userListType: UserListType) {
        self.userListType = userListType

        let userList = Services.cacheViewContext.userListManager.firstOrNew(withListType: userListType)

        self.apply(userList: userList, canShowState: false)

        self.refreshUserList()
    }

    private func apply(checkUsers: [User], check: Check) {
        Log.i("\(checkUsers.count), \(check.uid)")

        self.checkUsers = checkUsers
        self.check = check
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.configEmptyState()
        self.configTableRefreshControl()

        self.subscribeToConversationsEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData {
            self.apply(userListType: .all)
        }
    }
}

// MARK: - UITableViewDataSource

extension AddParticipantsTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId, for: indexPath)

        item.configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddParticipantsTableViewController: UITableViewDelegate {

    // MARK: - Instance Properties

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.userList[indexPath.row]

        self.selectedUsers.append(user)

        self.updateDoneBarButtonItemState()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user = self.userList[indexPath.row]

        self.selectedUsers.removeAll(where: { $0.uid == user.uid })

        self.updateDoneBarButtonItemState()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]

        if let imageURL = item.item.imageURL, let imageView = item.targetImageView(of: cell) {
            ImageDownloader.shared.loadImage(for: imageURL, in: imageView)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageView = self.items[indexPath.row].targetImageView(of: cell) {
            ImageDownloader.shared.cancelLoad(in: imageView)
        }
    }
}

// MARK: - DictionaryReceiver

extension AddParticipantsTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let checkUsers = dictionary["checkUsers"] as? [User], let check = dictionary["check"] as? Check else {
            return
        }

        self.apply(checkUsers: checkUsers, check: check)
    }
}
