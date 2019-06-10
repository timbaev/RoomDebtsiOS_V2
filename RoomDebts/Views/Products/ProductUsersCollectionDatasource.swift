//
//  ProductUsersCollectionDatasource.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class ProductUsersCollectionDatasource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Typealiases

    private typealias UserCellConfigurator = CollectionCellConfigurator<UserCollectionViewCell, UserViewModel>

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let userCollectionCellIdentifier = "UserCell"
    }

    // MARK: - Instance Properties

    private let items: [UserCellConfigurator]

    // MARK: -

    private var selectedIndexPaths = Set<IndexPath>() {
        didSet {
            self.onSelectedIndexPathsUpdated?(self.selectedIndexPaths)
        }
    }

    // MARK: -

    var onSelectedIndexPathsUpdated: ((Set<IndexPath>) -> Void)?

    // MARK: - Initializers

    init(usersViewModel: [UserViewModel]) {
        self.items = usersViewModel.map { UserCellConfigurator(item: $0) }
        let selectedIndexPaths = usersViewModel.enumerated().compactMap { index, userViewModel -> IndexPath? in
            if userViewModel.isSelected {
                return IndexPath(row: index, section: 0)
            } else {
                return nil
            }
        }

        self.selectedIndexPaths = Set<IndexPath>(selectedIndexPaths)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.userCollectionCellIdentifier, for: indexPath)

        self.items[indexPath.row].configure(cell: cell)

        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let targetImageView = self.items[indexPath.row].targetImageView(of: cell), let imageURL = self.items[indexPath.row].item.imageURL {
            ImageDownloader.shared.loadImage(for: imageURL, in: targetImageView, placeholder: #imageLiteral(resourceName: "AvatarPlaceholder.pdf"))
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < self.items.count else {
            return
        }

        if let targetImageView = self.items[indexPath.row].targetImageView(of: cell) {
            ImageDownloader.shared.cancelLoad(in: targetImageView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return false
        }

        if self.selectedIndexPaths.contains(indexPath) {
            cell.isSelected = false

            self.selectedIndexPaths.remove(indexPath)
        } else {
            self.selectedIndexPaths.insert(indexPath)

            cell.isSelected = true
        }

        return false
    }
}
