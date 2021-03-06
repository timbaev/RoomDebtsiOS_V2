//
//  SearchViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class SearchViewController: LoggedViewController, ErrorMessagePresenter, NVActivityIndicatorViewable {

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let userCellIdentifier = "UserCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    private var users: [User] = []

    private var searchTimer: Timer?

    // MARK: - Instance Methods

    private func configSearchController() {
        let search = UISearchController(searchResultsController: nil)

        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false

        search.searchBar.placeholder = "Name or Phone Number".localized()
        search.searchBar.setImage(#imageLiteral(resourceName: "SearchIcon.pdf"), for: .search, state: .normal)
        search.searchBar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "SearchFieldBackground.pdf"), for: .normal)
        search.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 7.0, vertical: 0.0)
        search.searchBar.tintColor = Colors.white

        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func configSearchTextField() {
        guard let searchTextField = self.navigationItem.searchController?.searchBar.textField else {
            return
        }

        searchTextField.textColor = Colors.white
        searchTextField.tintColor = Colors.white
    }

    // MARK: -

    private func loadAvatarImage(userTableCell cell: UserTableViewCell, at indexPath: IndexPath) {
        let user = self.users[indexPath.row]

        if let avatarImageURL = user.imageURL {
            var kf = cell.avatarImageViewTarget.kf

            kf.indicatorType = .activity
            kf.setImage(with: avatarImageURL, placeholder: #imageLiteral(resourceName: "AvatarPlaceholder.pdf"), options: [.transition(.fade(0.25))])
        } else {
            cell.avatar = #imageLiteral(resourceName: "AvatarPlaceholder.pdf")
        }
    }

    private func cancelLoadAvatarImage(userTableCell cell: UserTableViewCell) {
        cell.avatarImageViewTarget.kf.cancelDownloadTask()
    }

    // MARK: -

    private func config(userTableCell cell: UserTableViewCell, at indexPath: IndexPath) {
        let user = self.users[indexPath.row]

        if let firstName = user.firstName, let lastName = user.lastName {
            cell.name = "\(firstName) \(lastName)"
        } else {
            cell.name = nil
        }

        cell.isLastRow = (self.users.count - 1 == indexPath.row)
    }

    // MARK: -

    private func sendInvite(to user: User) {
        self.startAnimating(type: .ballScaleMultiple)

        Services.conversationService.create(opponentUID: user.uid, success: { [weak self] conversation in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.showMessage(withTitle: nil, message: "Invitation sent successfully".localized())
        }, failure: { [weak self] error in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()
            viewController.showMessage(withError: error)
        })
    }

    // MARK: -

    private func apply(users: [User]) {
        Log.i(users.count)

        self.users = users

        self.tableView.reloadData()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.definesPresentationContext = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.definesPresentationContext = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.configSearchTextField()
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCellIdentifier, for: indexPath)

        self.config(userTableCell: cell as! UserTableViewCell, at: indexPath)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.loadAvatarImage(userTableCell: cell as! UserTableViewCell, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cancelLoadAvatarImage(userTableCell: cell as! UserTableViewCell)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let user = self.users[indexPath.row]

        if let firstName = user.firstName, let lastName = user.lastName {
            let formattedMessage = String(format: "Send invite to %@ %@?".localized(), firstName, lastName)

            UIAlertController.Builder()
                .withTitle("Send Invite".localized())
                .withMessage(formattedMessage)
                .addOkAction(handler: { [unowned self] action in
                    self.sendInvite(to: user)
                })
                .addCancelAction()
                .show(in: self)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

    // MARK: - Instance Methods

    func updateSearchResults(for searchController: UISearchController) {
        self.searchTimer?.invalidate()

        guard let searchString = searchController.searchBar.text else {
            return
        }

        if searchString.count >= 3 {
            self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { timer in
                Services.userService.search(keyword: searchString, success: { users in
                    self.apply(users: users)
                }, failure: { [weak self] error in
                    self?.showMessage(withError: error)
                })
            })
        } else {
            self.apply(users: [])
        }
    }
}
