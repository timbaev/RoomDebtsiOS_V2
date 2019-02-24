//
//  SearchViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class SearchViewController: LoggedViewController {

    // MARK: - Nested Types

    fileprivate enum Constants {

        // MARK: - Type Properties

        static let searchCellIdentifier = "SearchCell"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Instance Methods

    private func configSearchController() {
        let search = UISearchController(searchResultsController: nil)

        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = true

        search.searchBar.placeholder = "Name or Phone Number".localized()
        search.searchBar.setImage(UIImage(named: "SearchBarIcon"), for: .search, state: .normal)
        search.searchBar.setSearchFieldBackgroundImage(UIImage(named: "SearchFieldBackground"), for: .normal)
        search.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 7.0, vertical: 0.0)

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

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configSearchController()
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
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.searchCellIdentifier, for: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate { }

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

    // MARK: - Instance Methods

    func updateSearchResults(for searchController: UISearchController) {
        //let searchString = searchController.searchBar.text
    }
}
