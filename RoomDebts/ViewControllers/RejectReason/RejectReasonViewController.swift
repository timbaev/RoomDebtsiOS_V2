//
//  RejectReasonViewController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/06/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class RejectReasonViewController: LoggedViewController {

    // MARK: - Instance Properties

    @IBOutlet private weak var alertView: RoundedView!
    @IBOutlet private weak var bottomSpacerHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var sendButton: Button!

    // MARK: -

    private var onSendButtonClicked: ((String) -> Void)?

    // MARK: - Instance Methods

    @IBAction private func onCloseButtonTouchUpInside(_ sender: RoundButton) {
        Log.i()

        self.performCloseAnimation(completion: { [unowned self] finished in
            self.dismiss(animated: false)
        })
    }

    @IBAction private func onSendButtonTouchUpInside(_ sender: Button) {
        Log.i()

        self.performCloseAnimation(completion: { [unowned self] finished in
            self.onSendButtonClicked?(self.textView.text)
            self.dismiss(animated: false)
        })
    }

    // MARK: -

    private func updateSendButtonState() {
        self.sendButton.isEnabled = self.textView.hasText
    }

    // MARK: -

    private func prepareAnimation() {
        self.view.backgroundColor = Colors.clear

        self.alertView.alpha = 0
        self.bottomSpacerHeightConstraint.priority = .defaultLow
    }

    private func performAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = Colors.black.withAlphaComponent(0.5)

            self.alertView.alpha = 1
            self.bottomSpacerHeightConstraint.priority = .defaultHigh

            self.view.layoutIfNeeded()
        })
    }

    private func performCloseAnimation(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = Colors.clear

            self.alertView.alpha = 0
            self.bottomSpacerHeightConstraint.priority = .defaultLow

            self.view.layoutIfNeeded()
        }, completion: completion)
    }

    // MARK: - Instance Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareAnimation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.performAnimation()
    }
}

// MARK: - DictionaryReceiver

extension RejectReasonViewController: DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any]) {
        guard let block = dictionary["onSendButtonClicked"] as? (String) -> Void else {
            return
        }

        self.onSendButtonClicked = block
    }
}

// MARK: - UITextViewDelegate

extension RejectReasonViewController: UITextViewDelegate {

    // MARK: - Instance Methods

    func textViewDidChange(_ textView: UITextView) {
        self.updateSendButtonState()
    }
}
