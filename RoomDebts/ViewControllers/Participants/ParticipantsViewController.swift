//
//  ParticipantsViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 25/05/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ParticipantsViewController: LoggedViewController, NVActivityIndicatorViewable, ErrorMessagePresenter {

    // MARK: - Typealiases

    private typealias ParticipantCellConfigurator = TableCellConfigurator<ParticipantTableViewCell, ParticipantViewModel>

    // MARK: - Nested Types

    private enum Constants {

        // MARK: - Type Properties

        static let checkSectionIndex = 0
        static let participantsSectionIndex = 1
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var checkImageView: RoundedImageView!
    @IBOutlet private weak var storeTextField: TextField!

    // MARK: -

    private var check: Check?
    private var users: [User]?

    private var items: [ParticipantCellConfigurator] = []

    private var shouldApplyData = true

    // MARK: - Instance Methods

    @objc private func onSaveBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        guard let storeName = self.storeTextField.text else {
            return
        }

        self.storeTextField.resignFirstResponder()

        self.startAnimating(type: .ballScaleMultiple)

        self.updateStoreName(storeName)
    }

    @objc private func onStoreTextFieldDidChange(_ sender: UITextField) {
        Log.i()

        self.updateSaveBarButtonItemState()
    }

    @IBAction private func onChangePhotoButtonTouchUpInside(_ sender: UIButton) {
        Log.i()
    }

    @IBAction private func onAddParticipantsControlTouchUpInside(_ sender: AddParticipantsControl) {
        Log.i()
    }

    // MARK: -

    private func updateSaveBarButtonItemState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = (self.storeTextField.hasText && self.storeTextField.text != self.check?.store)
    }

    // MARK: -

    private func updateStoreName(_ storeName: String) {
        guard let check = self.check else {
            return
        }

        Services.checkService.update(storeName: storeName, for: check, result: { [weak self] result in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            switch result {
            case .success(let check):
                viewController.check = check

                viewController.updateSaveBarButtonItemState()

            case .failure(let error):
                viewController.showMessage(withError: error)
            }
        })
    }

    // MARK: -

    private func apply(check: Check, users: [User]) {
        Log.i("\(check.uid), \(users.count)")

        self.check = check
        self.users = users

        self.items = users.map {
            var fullName: String?

            if let firstName = $0.firstName, let lastName = $0.lastName {
                fullName = "\(firstName) \(lastName)"
            }

            let userIsCleator = (check.creator?.uid == $0.uid)

            let viewModel = ParticipantViewModel(avatarURL: $0.imageURL,
                                                 name: fullName,
                                                 isCreatorLabelHidden: !userIsCleator)

            return ParticipantCellConfigurator(item: viewModel)
        }

        if self.isViewLoaded {
            self.storeTextField.text = check.store

            if let checkImageURL = check.imageURL {
                ImageDownloader.shared.loadImage(for: checkImageURL, in: self.checkImageView)
            }

            self.tableView.reloadData()

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: -

    private func configureSaveBarButtonItem() {
        let saveBarButtonItem = UIBarButtonItem(title: "Save".localized(),
                                                style: .done,
                                                target: self,
                                                action: #selector(self.onSaveBarButtonItemTouchUpInside(_:)))

        saveBarButtonItem.isEnabled = false
        saveBarButtonItem.tintColor = Colors.saveBarItem

        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func configureStoreTextField() {
        self.storeTextField.addTarget(self, action: #selector(self.onStoreTextFieldDidChange(_:)), for: .editingChanged)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSaveBarButtonItem()
        self.configureStoreTextField()

        self.subscribeToKeyboardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check, let users = self.users {
            self.apply(check: check, users: users)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }
}

// MARK: - DictionaryReceiver

extension ParticipantsViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let check = dictionary["check"] as? Check, let users = dictionary["users"] as? [User] else {
            return
        }

        self.apply(check: check, users: users)
    }
}

// MARK: - UITextFieldDelegate

extension ParticipantsViewController: UITextFieldDelegate {

    // MARK: - Instance Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }
}

// MARK: - KeyboardScrollableHandler

extension ParticipantsViewController: KeyboardScrollableHandler {

    // MARK: - Instance Properties

    var scrollableView: UITableView {
        return self.tableView
    }
}

// MARK: - UITableViewDataSource

extension ParticipantsViewController: UITableViewDataSource {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellConfigurator = self.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellConfigurator.reuseId, for: indexPath)

        cellConfigurator.configure(cell: cell)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ParticipantsViewController: UITableViewDelegate {

    // MARK: - Instance Methods

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellConfigurator = self.items[indexPath.row]

        if let targetImageView = cellConfigurator.targetImageView(of: cell), let avatarImageURL = cellConfigurator.item.avatarURL {
            ImageDownloader.shared.loadImage(for: avatarImageURL, in: targetImageView)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let cellConfigurator = self.items[indexPath.row]

        if let targetImageView = cellConfigurator.targetImageView(of: cell) {
            ImageDownloader.shared.cancelLoad(in: targetImageView)
        }
    }
}
