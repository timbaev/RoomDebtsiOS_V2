//
//  UIAlertControllerExtension.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 28/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

extension UIAlertController {

    // MARK: - Nested Types

    public class Builder {

        // MARK: - Instance Properties

        private var preferredStyle: UIAlertController.Style = .alert
        private var title: String?
        private var message: String?
        private var actions: [UIAlertAction] = []

        // MARK: - Instance Methods

        private func build() -> UIAlertController {
            let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.preferredStyle)

            actions.forEach { alert.addAction($0) }

            return alert
        }

        // MARK: -

        func preferredStyle(_ style: UIAlertController.Style) -> Builder {
            self.preferredStyle = style

            return self
        }

        func withTitle(_ title: String?) -> Builder {
            self.title = title

            return self
        }

        func withMessage(_ message: String?) -> Builder {
            self.message = message

            return self
        }

        func addOkAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addDefaultAction(withTitle: "OK".localized(), handler: handler)
        }

        func addDeleteAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addDestructiveAction(withTitle: "Delete".localized(), handler: handler)
        }

        func addCancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addCancelAction(withTitle: "Cancel".localized(), handler: handler)
        }

        func addDefaultAction(withTitle title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addAction(withTitle: title, style: .default, handler: handler)
        }

        func addDestructiveAction(withTitle title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addAction(withTitle: title, style: .destructive, handler: handler)
        }

        func addCancelAction(withTitle title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return self.addAction(withTitle: title, style: .cancel, handler: handler)
        }

        func addAction(withTitle title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            let action = UIAlertAction(title: title, style: style, handler: handler)

            self.actions.append(action)

            return self
        }

        func show(in viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
            switch self.preferredStyle {
            case .alert:
                viewController.present(alertController: self.build(), animated: animated, completion: completion)

            case .actionSheet:
                viewController.present(self.build(), animated: animated, completion: completion)
            }
        }
    }
}
