//
//  DebtsTableViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 04/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class DebtsTableViewController: LoggedViewController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let showCreateDebt = "ShowCreateDebt"
    }

    // MARK: - Instance Properties

    private var conversation: Conversation?

    // MARK: -

    private(set) var isRefreshingData = false
    private(set) var shouldApplyData = true

    // MARK: - Instance Methods

    @objc private func onPlusButtonTouchUpInside(sender: UIBarButtonItem) {
        Log.i()

        guard let conversation = self.conversation else {
            return
        }

        self.performSegue(withIdentifier: Segues.showCreateDebt, sender: conversation)
    }

    // MARK: -

    private func configPlusBarButtonItem() {
        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onPlusButtonTouchUpInside(sender:)))

        plusBarButtonItem.tintColor = Colors.barItem

        self.navigationItem.rightBarButtonItem = plusBarButtonItem
    }

    // MARK: -

    private func apply(conversation: Conversation) {
        Log.i(conversation.uid)

        self.conversation = conversation

        if self.isViewLoaded {
            let userIsCreator = (conversation.creator?.uid == Services.userAccount?.uid)
            let opponent = userIsCreator ? conversation.opponent : conversation.creator

            if let firstName = opponent?.firstName, let lastName = opponent?.lastName {
                self.navigationItem.title = "\(firstName) \(lastName)"
            }

            self.shouldApplyData = false
        } else {
            self.shouldApplyData = true
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldApplyData = true

        self.configPlusBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.shouldApplyData, let conversation = self.conversation {
            self.apply(conversation: conversation)
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
        case Segues.showCreateDebt:
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

// MARK: - DictionaryReceiver

extension DebtsTableViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let conversation = dictionary["conversation"] as? Conversation else {
            return
        }

        self.apply(conversation: conversation)
    }
}
