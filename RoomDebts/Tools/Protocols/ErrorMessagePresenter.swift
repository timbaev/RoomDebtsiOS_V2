//
//  AlertPresenter.swift
//  Wager
//
//  Created by Almaz Ibragimov on 06.06.2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import UIKit

protocol ErrorMessagePresenter {
    
    // MARK: - Instance Properties
    
    var presenterController: UIViewController { get }
    
    // MARK: - Instance Methods
    
    func showMessage(withTitle title: String?, message: String?, okHandler: (() -> Void)?)
    func showMessage(withError error: Error, okHandler: (() -> Void)?)
}

// MARK: -

extension ErrorMessagePresenter where Self: UIViewController {
    
    // MARK: - Instance Properties
    
    var presenterController: UIViewController {
        return self
    }
    
    // MARK: - Instance Methods
    
    func showMessage(withTitle title: String?, message: String?, okHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: { action in
            okHandler?()
        }))
        
        self.present(alertController: alertController, animated: true)
    }
    
    func showMessage(withTitle title: String?, message: String?) {
        self.showMessage(withTitle: title, message: message, okHandler: nil)
    }
    
    func showMessage(withError error: Error, okHandler: (() -> Void)?) {
        if let webError = error as? WebError {
            switch webError.code {
            case .connection, .timeOut:
                self.showMessage(withTitle: "No Internet Connection".localized(),
                                 message: "Check your wi-fi or mobile data connection.".localized(),
                                 okHandler: okHandler)
                
            default:
                if let message = webError.message {
                    self.showMessage(withTitle: "Error".localized(), message: message)
                } else {
                    self.showMessage(withTitle: "Something went wrong".localized(),
                                     message: "Please let us know what went wrong or try again later.".localized(),
                                     okHandler: okHandler)
                }
            }
        } else {
            self.showMessage(withTitle: "Something went wrong".localized(),
                             message: "Please let us know what went wrong or try again later.".localized(),
                             okHandler: okHandler)
        }
    }
    
    func showMessage(withError error: Error) {
        self.showMessage(withError: error, okHandler: nil)
    }
}
