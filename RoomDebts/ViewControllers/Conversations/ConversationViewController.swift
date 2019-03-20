//
//  ConversationViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ConversationViewController: LoggedViewController, EmptyStateViewable, NVActivityIndicatorViewable, ErrorMessagePresenter {

    // MARK: - Type Aliases

    private typealias ConversationCellConfigurator = TableCellConfigurator<ConversationTableViewCell, ConversationTableViewModel>

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let conversationTableCellIdentifier = "ConversationCell"
    }

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showDebts = "ShowDebts"
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

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromConversationsEvents()
        self.unsubscribeFromDebtsEvents()
    }

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
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .badRequest:
            if let message = error.message {
                if self.conversationList?.isEmpty ?? true {
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
            if self.conversationList?.isEmpty ?? true {
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

    private func config(conversationTableCell cell: ConversationTableViewCell, at indexPath: IndexPath) {
        let conversation = self.conversationList[indexPath.row]

        let viewModel = ConversationTableViewModel(conversation: conversation)

        ConversationCellConfigurator(item: viewModel).configure(cell: cell)

        cell.onAcceptButtonClick = { [unowned self] in
            self.acceptConversation(conversation)
        }

        cell.onDeclineButtonClick = { [unowned self] in
            self.rejectConversation(conversation)
        }

        cell.onMoreButtonClick = { [unowned self] in
            self.showActions(for: conversation, userIsCreator: viewModel.userIsCreator)
        }
    }

    private func showActions(for conversation: Conversation, userIsCreator: Bool) {
        var builder = UIAlertController.Builder()
            .preferredStyle(.actionSheet)
            .withTitle("Actions".localized())
            .addCancelAction()

        switch conversation.status {
        case .accepted?:
            builder = builder.withMessage("All actions opponent should approve".localized())
                .addDefaultAction(withTitle: "Repay All Debts".localized(), handler: { [unowned self] action in
                    self.sendRepayRequest(for: conversation)
            })

        case .invited?:
            builder = builder.withMessage("Conversation can be delete without opponent approve".localized())

        case .repayRequest?:
            if userIsCreator {
                builder = builder.withMessage("Delete action opponent should approve".localized())
                    .addDefaultAction(withTitle: "Cancel Repay Request".localized(), handler: { [unowned self] action in
                        self.cancelRequest(for: conversation)
                    })
            }

        case .deleteRequest?:
            if userIsCreator {
                builder = builder.addDefaultAction(withTitle: "Cancel Delete Request".localized(), handler: { [unowned self] action in
                    self.cancelRequest(for: conversation)
                })
            }

        case nil:
            fatalError()
        }

        if conversation.status != .deleteRequest {
            builder = builder.addDestructiveAction(withTitle: "Delete Conversation".localized(), handler: { [unowned self] action in
                if conversation.status != .invited {
                    self.sendDeleteRequest(for: conversation)
                }
            })
        }

        builder.show(in: self)
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

    private func acceptConversation(_ conversation: Conversation) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.accept(conversationUID: conversation.uid, success: { [weak self] updatedConversation in
            guard let viewController = self else {
                return
            }

            if updatedConversation == nil {
                viewController.stopAnimating()
                viewController.conversationList.remove(conversation: conversation)
                viewController.tableView.reloadData()
            } else {
                viewController.refreshConversationList()
            }
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func rejectConversation(_ conversation: Conversation) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.reject(conversationUID: conversation.uid, success: { [weak self] updatedConversation in
            guard let viewController = self else {
                return
            }

            if updatedConversation == nil {
                viewController.stopAnimating()
                viewController.conversationList.remove(conversation: conversation)
                viewController.tableView.reloadData()
            } else {
                viewController.refreshConversationList()
            }
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func sendRepayRequest(for conversation: Conversation) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.repayRequest(for: conversation.uid, success: { [weak self] conversation in
            self?.refreshConversationList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func sendDeleteRequest(for conversation: Conversation) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.deleteRequest(for: conversation.uid, success: { [weak self] conversation in
            self?.refreshConversationList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    private func cancelRequest(for conversation: Conversation) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.cancelRequest(for: conversation.uid, success: { [weak self] conversation in
            self?.refreshConversationList()
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.handle(stateError: error)
        })
    }

    // MARK: -

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

        if self.isAnimating {
            self.stopAnimating()
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

        self.subscribeToConversationsEvents()
        self.subscribeToDebtsEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData {
            self.apply(conversationListType: .all)
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
        case Segues.showDebts:
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = self.conversationList[indexPath.row]

        if conversation.status != .invited {
            self.performSegue(withIdentifier: Segues.showDebts, sender: conversation)
        }
    }
}
