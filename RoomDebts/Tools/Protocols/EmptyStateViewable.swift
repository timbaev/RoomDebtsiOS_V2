//
//  EmptyStateViewable.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 03/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

protocol EmptyStateViewable {

    // MARK: - Instance Properties

    var emptyStateContainerView: UIView { get }
    var emptyStateView: EmptyStateView { get }

    // MARK: - Instance Methods

    func initialize()

    func showEmptyState(image: UIImage?, title: String?, message: String, action: EmptyStateAction?)
    func showEmptyState(title: String?, message: String)

    func showNoDataState(with message: String)
    func showNoDataState()

    func showLoadingState(with title: String?, message: String)

    func hideEmptyState()
}

// MARK: -

extension EmptyStateViewable where Self: UIViewController {

    // MARK: - Instance Methods

    func initialize() {
        self.emptyStateContainerView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.emptyStateContainerView)

        self.emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        self.emptyStateContainerView.addSubview(self.emptyStateView)

        NSLayoutConstraint.activate([self.emptyStateContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     self.emptyStateContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     self.emptyStateContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     self.emptyStateContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])

        NSLayoutConstraint.activate([self.emptyStateView.topAnchor.constraint(equalTo: self.emptyStateContainerView.topAnchor),
                                     self.emptyStateView.leadingAnchor.constraint(equalTo: self.emptyStateContainerView.leadingAnchor),
                                     self.emptyStateView.bottomAnchor.constraint(equalTo: self.emptyStateContainerView.bottomAnchor),
                                     self.emptyStateView.trailingAnchor.constraint(equalTo: self.emptyStateContainerView.trailingAnchor)])
    }

    func showEmptyState(image: UIImage?, title: String?, message: String, action: EmptyStateAction?) {
        if self.emptyStateContainerView.subviews.isEmpty {
            self.initialize()
        }

        self.emptyStateView.hideActivityIndicator()

        self.emptyStateView.image = image
        self.emptyStateView.title = title
        self.emptyStateView.message = message
        self.emptyStateView.action = action

        self.emptyStateContainerView.isHidden = false
    }

    func showEmptyState(title: String?, message: String) {
        self.showEmptyState(image: nil, title: title, message: message, action: nil)
    }

    func showNoDataState(with message: String) {
        self.showEmptyState(title: nil, message: message)
    }

    func showNoDataState() {
        self.showEmptyState(title: nil, message: "Nothing found".localized())
    }

    func showLoadingState(with title: String?, message: String) {
        if self.emptyStateContainerView.isHidden {
            self.showEmptyState(title: title, message: message)
        }

        self.emptyStateView.showActivityIndicator()
    }

    func hideEmptyState() {
        self.emptyStateContainerView.isHidden = true
    }
}
