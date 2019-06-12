//
//  ReviewTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ReviewTableViewController: LoggedViewController, EmptyStateViewable, ErrorMessagePresenter {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let unauthorized = "Unauthorized"
    }

    // MARK: -

    private enum Constants {

        // MARK: - Type Properties

        static let totalTableCellIdentifier = "TotalTableCell"
        static let reviewTableCellIdentifier = "ReviewTableCell"
        static let sectionHeaderCellIdentifier = "SectionHeaderCell"

        static let resultsSectionIndex = 0
        static let reviewsSectionIndex = 1
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var checkStatusLabel: UILabel!
    @IBOutlet private weak var checkStatusImageView: UIImageView!

    private weak var tableRefreshControl: UIRefreshControl!

    // MARK: -

    private var check: Check?

    private var checkUserList: CheckUserList!
    private var checkUserListType: CheckUserListType = .unknown

    private var reviews: [CheckUser] = []

    private var shouldApplyData = true
    private var isRefreshingData = false

    // MARK: - EmptyStateViewable

    var emptyStateContainerView = UIView()
    var emptyStateView = EmptyStateView()

    // MARK: - Instance Methods

    @objc private func onTableRefreshControlRequested(_ sender: Any) {
        Log.i()

        self.refreshReviews()
    }

    // MARK: -

    private func handle(stateError error: WebError, retryHandler: (() -> Void)? = nil) {
        let action = EmptyStateAction(title: "Try Again".localized(), onClicked: {
            retryHandler?()
        })

        switch error {
        case .connection, .timeOut:
            if self.checkUserList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                    title: Messages.internetConncetionTitle,
                                    message: Messages.internetConnection,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .badRequest:
            if let message = error.message {
                if self.checkUserList?.isEmpty ?? true {
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
            if self.checkUserList?.isEmpty ?? true {
                self.showEmptyState(image: #imageLiteral(resourceName: "ErrorWarning.pdf"),
                                    title: Messages.unknownErrorTitle,
                                    message: Messages.unknownError,
                                    action: action)
            } else {
                self.showMessage(withTitle: Messages.unknownErrorTitle, message: Messages.unknownError)
            }
        }
    }

    private func refreshReviews() {
        Log.i()

        guard let check = self.check else {
            return
        }

        self.isRefreshingData = true

        if !self.tableRefreshControl.isRefreshing {
            if (self.checkUserList.isEmpty) || (!self.emptyStateContainerView.isHidden) {
                self.showLoadingState(with: "Loading reviews".localized(),
                                      message: "We are loading list of reviews. Please wait a bit".localized())
            }
        }

        Services.checkService.fetchReviews(for: check.uid, response: { [weak self] result in
            guard let `self` = self else {
                return
            }

            switch result {
            case .success(let checkUserList):
                self.apply(checkUserList: checkUserList)

            case .failure(let error):
                self.handle(stateError: error, retryHandler: { [weak self] in
                    self?.refreshReviews()
                })
            }
        })
    }

    // MARK: -

    private func apply(check: Check) {
        Log.i(check.uid)

        self.check = check

        if self.isViewLoaded {
            self.checkStatusLabel.text = check.status?.title
            self.checkStatusImageView.image = check.status?.image

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(checkUserList: CheckUserList, canShowState: Bool = true) {
        Log.i(checkUserList.count)

        self.checkUserList = checkUserList
        self.reviews = checkUserList.checkUsers.filter {
            $0.status == .some(.accepted) || $0.status == .some(.rejected)
        }

        if self.isViewLoaded {
            if checkUserList.isEmpty && canShowState {
                self.showNoDataState(with: "Reviews not found".localized())
            } else {
                self.hideEmptyState()
            }

            if self.tableRefreshControl.isRefreshing {
                self.tableRefreshControl.endRefreshing()
            }

            self.isRefreshingData = false

            self.tableView.reloadData()

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(checkUserListType: CheckUserListType) {
        Log.i(checkUserListType.checkUID)

        self.checkUserListType = checkUserListType

        self.apply(checkUserList: Services.cacheViewContext.checkUserListManager.firstOrNew(withListType: checkUserListType))

        self.refreshReviews()
    }

    // MARK: -

    private func configureTableRefreshControl() {
        let tableRefreshControl = UIRefreshControl()

        tableRefreshControl.tintColor = Colors.white

        tableRefreshControl.addTarget(self,
                                      action: #selector(self.onTableRefreshControlRequested(_:)),
                                      for: .valueChanged)

        self.tableView.refreshControl = tableRefreshControl
        self.tableRefreshControl = tableRefreshControl
    }

    // MARK: -

    private func configure(totalTableCell cell: TotalTableViewCell, at indexPath: IndexPath) {
        let checkUser = self.checkUserList[indexPath.row]

        cell.name = checkUser.user?.fullName
        cell.reviewStatusImage = checkUser.status?.image
        cell.total = String(format: "%.2f₽".localized(), checkUser.total)
    }

    private func configure(reviewTableCell cell: ReviewTableViewCell, at indexPath: IndexPath) {
        let checkUser = self.reviews[indexPath.row]

        cell.reviewStatusImage = checkUser.status?.image
        cell.name = checkUser.user?.firstName

        if let date = checkUser.reviewDate, let status = checkUser.status {
            cell.status = ReviewDateFormatter.shared.string(from: date, reviewStatus: status)
        } else {
            cell.status = nil
        }

        if let message = checkUser.comment {
            cell.message = message
        } else {
            cell.message = nil
            cell.messageIsHidden = true
        }
    }

    private func configure(sectionHeaderCell cell: SectionHeaderTableViewCell, at section: Int) {
        switch section {
        case Constants.resultsSectionIndex:
            cell.title = "Results".localized()

        case Constants.reviewsSectionIndex:
            cell.title = "Reviews".localized()

        default:
            fatalError()
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.configureTableRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
            self.apply(checkUserListType: .check(uid: check.uid))
        }
    }
}

// MARK: - DictionaryReceiver

extension ReviewTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        if let check = dictionary["check"] as? Check {
            self.apply(check: check)
        }

        if let checkUserList = dictionary["checkUserList"] as? CheckUserList {
            self.apply(checkUserList: checkUserList)
        }
    }
}

// MARK: - UITableViewDataSource

extension ReviewTableViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.resultsSectionIndex:
            return self.checkUserList.count

        case Constants.reviewsSectionIndex:
            return self.reviews.count

        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        switch indexPath.section {
        case Constants.resultsSectionIndex:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.totalTableCellIdentifier, for: indexPath)

            self.configure(totalTableCell: cell as! TotalTableViewCell, at: indexPath)

        case Constants.reviewsSectionIndex:
            cell = tableView.dequeueReusableCell(withIdentifier: Constants.reviewTableCellIdentifier, for: indexPath)

            self.configure(reviewTableCell: cell as! ReviewTableViewCell, at: indexPath)

        default:
            fatalError()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sectionHeaderCellIdentifier) else {
            return nil
        }

        self.configure(sectionHeaderCell: cell as! SectionHeaderTableViewCell, at: section)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ReviewTableViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let totalTableViewCell = cell as? TotalTableViewCell else {
            return
        }

        if let imageURL = self.checkUserList[indexPath.row].user?.imageURL {
            ImageDownloader.shared.loadImage(for: imageURL, in: totalTableViewCell.imageViewTarget)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let totalTableViewCell = cell as? TotalTableViewCell else {
            return
        }

        ImageDownloader.shared.cancelLoad(in: totalTableViewCell.imageViewTarget)
    }
}
