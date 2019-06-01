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

    // MARK: -

    private enum Segues {

        // MARK: - Type Properties

        static let showAddParticipants = "ShowAddParticipants"
    }

    // MARK: - Instance Properties

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var checkImageView: RoundedImageView!
    @IBOutlet private weak var storeTextField: TextField!

    // MARK: -

    private let imagePicker: ImagePicker = DefaultImagePicker()

    // MARK: -

    private var check: Check?
    private var users: [User]?

    private var items: [ParticipantCellConfigurator] = []

    private var shouldApplyData = true

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromProductListEvents()
    }

    // MARK: - Instance Methods

    @objc private func onSaveBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        Log.i()

        guard let storeName = self.storeTextField.text else {
            return
        }

        self.storeTextField.resignFirstResponder()

        self.updateStoreName(storeName)
    }

    @objc private func onStoreTextFieldDidChange(_ sender: UITextField) {
        Log.i()

        self.updateSaveBarButtonItemState()
    }

    @IBAction private func onChangePhotoButtonTouchUpInside(_ sender: UIButton) {
        Log.i()

        self.imagePicker.presentPickerActionSheet(from: self, selectedImage: { [unowned self] image in
            self.updateImage(image)
        })
    }

    @IBAction private func onAddParticipantsControlTouchUpInside(_ sender: AddParticipantsControl) {
        Log.i()

        guard let checkUsers = self.users else {
            return
        }

        self.performSegue(withIdentifier: Segues.showAddParticipants, sender: checkUsers)
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

        self.startAnimating()

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

    private func updateImage(_ image: UIImage) {
        guard let check = self.check else {
            return
        }

        self.startAnimating()

        Services.checkService.upload(image: image, for: check, result: { [weak self] result in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            switch result {
            case .success(let check):
                viewController.check = check
                viewController.checkImageView.image = image

            case .failure(let error):
                viewController.showMessage(withError: error)
            }
        })
    }

    private func removeParticipant(user: User) {
        guard let check = self.check else {
            return
        }

        self.startAnimating()

        Services.checkService.removeParticipant(userUID: user.uid, for: check, response: { [weak self] result in
            guard let viewController = self else {
                return
            }

            viewController.stopAnimating()

            switch result {
            case .success(let productList):
                viewController.apply(users: productList.users)

            case .failure(let error):
                viewController.showMessage(withError: error)
            }
        })
    }

    // MARK: -

    private func apply(check: Check) {
        Log.i(check.uid)

        self.check = check

        let productList = Services.cacheViewContext.productListManager.firstOrNew(withListType: .check(uid: check.uid))

        self.apply(users: productList.users)

        if self.isViewLoaded {
            self.storeTextField.text = check.store

            if let checkImageURL = check.imageURL {
                ImageDownloader.shared.loadImage(for: checkImageURL, in: self.checkImageView)
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    private func apply(users: [User]) {
        Log.i(users.count)

        self.users = users

        self.items = users.map {
            var fullName: String?

            if let firstName = $0.firstName, let lastName = $0.lastName {
                fullName = "\(firstName) \(lastName)"
            }

            let userIsCleator = (self.check?.creator?.uid == $0.uid)

            let viewModel = ParticipantViewModel(avatarURL: $0.imageURL,
                                                 name: fullName,
                                                 isCreatorLabelHidden: !userIsCleator)

            return ParticipantCellConfigurator(item: viewModel)
        }

        if self.isViewLoaded {
            self.tableView.reloadData()

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: -

    private func subscribeToProductListEvents() {
        self.unsubscribeFromProductListEvents()

        let productListManager = Services.cacheViewContext.productListManager

        productListManager.objectsChangedEvent.connect(self, handler: { [weak self] _ in
            self?.shouldApplyData = true
        })

        productListManager.startObserving()
    }

    private func unsubscribeFromProductListEvents() {
        Services.cacheViewContext.productListManager.objectsChangedEvent.disconnect(self)
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
        self.subscribeToProductListEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let check = self.check {
            self.apply(check: check)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.identifier {
        case Segues.showAddParticipants:
            guard let checkUsers = sender as? [User] else {
                fatalError()
            }

            guard let check = self.check else {
                fatalError()
            }

            let dictionaryReceiver: DictionaryReceiver?

            if let navigationController = segue.destination as? UINavigationController {
                dictionaryReceiver = navigationController.viewControllers.first as? DictionaryReceiver
            } else {
                dictionaryReceiver = segue.destination as? DictionaryReceiver
            }

            if let dictionaryReceiver = dictionaryReceiver {
                dictionaryReceiver.apply(dictionary: ["checkUsers": checkUsers, "check": check])
            }

        default:
            return
        }
    }
}

// MARK: - DictionaryReceiver

extension ParticipantsViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let check = dictionary["check"] as? Check else {
            return
        }

        self.apply(check: check)
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
        guard indexPath.row < self.items.count else {
            return
        }

         let cellConfigurator = self.items[indexPath.row]

        if let targetImageView = cellConfigurator.targetImageView(of: cell) {
            ImageDownloader.shared.cancelLoad(in: targetImageView)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let users = self.users else {
            return false
        }

        return users[indexPath.row].uid != Services.userAccount?.uid
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        guard let user = self.users?[indexPath.row] else {
            return
        }

        UIAlertController.Builder()
            .withTitle("Confirmation".localized())
            .withMessage("Delete \(user.fullName ?? "participant") from check?".localized())
            .addDeleteAction(handler: { [unowned self] action in
                self.removeParticipant(user: user)
            })
            .addCancelAction()
            .show(in: self)
    }
}
