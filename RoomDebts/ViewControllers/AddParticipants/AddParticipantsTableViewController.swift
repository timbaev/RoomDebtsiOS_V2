//
//  AddParticipantsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 31/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class AddParticipantsTableViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter {

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
            let action = EmptyStateAction(title: "Create debt conversation", onClicked: { [unowned self] in
                self.tabBarController?.selectedIndex = Tabs.search.rawValue
            })

            self.showNoDataState(with: "You have not debt conversations with users", action: action)
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
    }

    private func apply(checkUsers: [User]) {
        Log.i(checkUsers.count)

        self.checkUsers = checkUsers
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
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user = self.userList[indexPath.row]

        self.selectedUsers.removeAll(where: { $0.uid == user.uid })
    }
}

// MARK: - DictionaryReceiver

extension AddParticipantsTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let checkUsers = dictionary["checkUsers"] as? [User] else {
            return
        }

        self.apply(checkUsers: checkUsers)
    }
}
