//
//  ConversationViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ConversationViewController: LoggedViewController, EmptyStateViewable {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let conversationTableCellIdentifier = "ConversationCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: -

    private(set) var conversationList: ConversationList!
    private(set) var conversationListType: ConversationListType = .unknown

    private(set) var isRefreshingData = false
    private(set) var shouldApplyData = true

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshConversationList()
    }

    // MARK: -

    private func handle(stateError error: WebError, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error {
        case .connection, .timeOut:
            if self.conversationList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: "No Internet Connection".localized(),
                                    message: "RoomDebts app requires an internet connection to provide offers. Please check your connection and try again.".localized(),
                                    action: action)
            }

        case .badRequest:
            if let message = error.message {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: "Something went wrong".localized(),
                                    message: message,
                                    action: action)
            } else {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: "Something went wrong".localized(),
                                    message: "RoomDebts can’t process your request at the moment. \n Please, try again later.".localized(),
                                    action: action)
            }

        default:
            if self.conversationList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: "Something went wrong".localized(),
                                    message: "RoomDebts can’t process your request at the moment. \n Please, try again later.".localized(),
                                    action: action)
            }
        }
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

    private func config(conversationTableCell cell: ConversationTableViewCell, at indexPath: IndexPath) {
        let conversation = self.conversationList[indexPath.row]

        let userIsCreator = (conversation.creator?.uid == Services.userAccount?.uid)
        let userIsDebtor = (conversation.debtorUID == Services.userAccount?.uid)
        let opponent = userIsCreator ? conversation.opponent : conversation.creator

        if let firstName = opponent?.firstName, let lastName = opponent?.lastName {
            cell.opponentName = "\(firstName) \(lastName)"
        } else {
            cell.opponentName = nil
        }

        if let status = conversation.status {
            switch status {
            case .accepted:
                cell.isShowActions = false

                if conversation.price > 0 {
                    if userIsDebtor {
                        cell.status = "Repay".localized()
                        cell.priceTextColor = Colors.red
                    } else {
                        cell.status = "Get".localized()
                        cell.priceTextColor = Colors.green
                    }
                } else {
                    cell.status = "No debts".localized()
                    cell.priceTextColor = Colors.gray
                }

            case .invited:
                if userIsCreator {
                    cell.status = "Waiting for confirmation".localized()
                    cell.isShowActions = false
                } else {
                    cell.status = "Confirm invitation".localized()
                    cell.isShowActions = true
                }
            }
        } else {
            cell.status = nil
            cell.isShowActions = false
        }

        cell.price = String(format: "%.2f₽", conversation.price)
        cell.isVisited = false
    }

    // MARK: -

    private func loadOpponentAvatarImage(conversationTableCell cell: ConversationTableViewCell, at indexPath: IndexPath) {
        let conversation = self.conversationList[indexPath.row]

        let userIsCreator = (conversation.creator?.uid == Services.userAccount?.uid)
        let opponent = userIsCreator ? conversation.opponent : conversation.creator

        if let avatarURL = opponent?.imageURL {
            ImageDownloader.shared.loadImage(for: avatarURL, in: cell.avatarImageViewTarget, placeholder: #imageLiteral(resourceName: "AvatarPlaceholder.pdf"))
        }
    }

    private func cancelLoadOpponentAvatarImage(conversationTableCell cell: ConversationTableViewCell) {
        ImageDownloader.shared.cancelLoad(in: cell.avatarImageViewTarget)
    }

    // MARK: -

    private func refreshConversationList() {
        Log.i()

        self.isRefreshingData = true

        if !self.tableRefreshControl.isRefreshing {
            if (self.conversationList.isEmpty) || (!self.emptyStateContainerView.isHidden) {
                self.showLoadingState(with: "Loading conversations".localized(),
                                      message: "We are loading list of conversations. Please wait a bit".localized())
            }
        }

        Services.conversationService.fetch(success: { [weak self] conversationList in
            guard let viewController = self else {
                return
            }

            viewController.apply(conversationList: conversationList)
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.handle(stateError: error, retryHandler: { [weak self] in
                self?.refreshConversationList()
            })
        })
    }

    private func apply(conversationList: ConversationList, canShowState: Bool = true) {
        Log.i(conversationList.count)

        self.conversationList = conversationList

        if conversationList.isEmpty && canShowState {
            self.showNoDataState(with: "Conversations not exists".localized())
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

    private func apply(conversationListType: ConversationListType) {
        self.conversationListType = conversationListType

        if self.isViewLoaded {
            self.apply(conversationList: Services.cacheViewContext.conversationListManager.firstOrNew(withListType: conversationListType), canShowState: false)

            self.refreshConversationList()

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData {
            self.apply(conversationListType: .all)
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.conversationTableCellIdentifier, for: indexPath)

        self.config(conversationTableCell: cell as! ConversationTableViewCell, at: indexPath)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.loadOpponentAvatarImage(conversationTableCell: cell as! ConversationTableViewCell, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cancelLoadOpponentAvatarImage(conversationTableCell: cell as! ConversationTableViewCell)
    }
}
