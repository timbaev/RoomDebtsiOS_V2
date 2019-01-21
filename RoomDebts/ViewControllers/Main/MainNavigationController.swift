//
//  MainNavigationController.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

class MainNavigationController: LoggedNavigationController {
    
    // MARK: - UINavigationController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        
        self.navigationBar.titleTextAttributes = [.foregroundColor: Colors.navigationTitle]
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.navigationTitle]
        self.navigationBar.tintColor = Colors.navigationTint
    }
}
