//
//  UIViewControllerExtension.swift
//  Wager
//
//  Created by Oleg Gorelov on 23/09/2018.
//  Copyright © 2018 Influx. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Instance Methods
    
    func present(alertController: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
        let backgroundView = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        backgroundView.backgroundColor = Colors.lightGrayBackground
        backgroundView.layer.cornerRadius = 10
        
        if let title = alertController.title {
            let titleMutableString = NSMutableAttributedString(string: title,
                                                               attributes: [NSAttributedString.Key.font: Fonts.medium(ofSize: 17),
                                                                            NSAttributedString.Key.foregroundColor: Colors.white])
            
            alertController.setValue(titleMutableString, forKey: "attributedTitle")
        }
        
        if let message = alertController.message {
            let messageMutableString = NSMutableAttributedString(string: message,
                                                                 attributes: [NSAttributedString.Key.font: Fonts.regular(ofSize: 13),
                                                                              NSAttributedString.Key.foregroundColor: Colors.white])
        
            alertController.setValue(messageMutableString, forKey: "attributedMessage")
        }
        
        alertController.view.tintColor = Colors.PrimaryButton.third
        
        self.present(alertController, animated: animated, completion: completion)
    }
}
