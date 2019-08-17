//
//  TextField.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 05/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

@IBDesignable class TextField: LocalizableTextField {

    // MARK: - Instance Properties

    @IBInspectable var placeholderColor: UIColor = Colors.textPlaceholder {
        didSet {
            self.applyState()
        }
    }

    @IBInspectable var showToolbar: Bool = false {
        didSet {
            self.applyState()
        }
    }

    // MARK: -

    var onNextButtonClick: (() -> Void)?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.applyState()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.applyState()
    }

    // MARK: - Instance Methods

    @objc private func onNextBarButtonItemTouchUpInside(_ sender: UIBarButtonItem) {
        self.onNextButtonClick?()
    }

    // MARK: -

    private func applyState() {
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: self.placeholderColor])
        }

        if self.showToolbar {
            let toolbar = UIToolbar()

            toolbar.barStyle = .default
            toolbar.isTranslucent = false
            toolbar.tintColor = Colors.PrimaryButton.third
            toolbar.barTintColor = Colors.dark

            let nextButton = UIBarButtonItem(title: "Next".localized(), style: .plain, target: self, action: #selector(self.onNextBarButtonItemTouchUpInside(_:)))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            toolbar.setItems([spaceButton, nextButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            toolbar.sizeToFit()

            self.inputAccessoryView = toolbar
        } else {
            self.inputAccessoryView = nil
        }
    }
}
