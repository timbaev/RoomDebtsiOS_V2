//
//  MainTabBarController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class MainTabBarController: LoggedTabBarController {

    // MARK: - Nested Types

    private enum Segues {

        // MARK: - Type Properties

        static let unauthorized = "Unauthorized"
    }

    // MARK: - Instance Methods

    @IBAction private func onAutorizationFinished(_ segue: UIStoryboardSegue) {
        Log.i(String(describing: segue.identifier))
    }

    // MARK: - UITabBarController

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [Colors.TabBarGradient.first, Colors.TabBarGradient.second].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

        self.tabBar.layer.sublayers?.insert(gradientLayer, at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Services.userAccount == nil {
            self.performSegue(withIdentifier: Segues.unauthorized, sender: self)
        }
    }
}
