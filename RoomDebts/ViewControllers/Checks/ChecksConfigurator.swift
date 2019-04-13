//
//  ChecksConfigurator.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

class ChecksConfigurator: NSObject {

    // MARK: - Instance Properties

    @IBOutlet private weak var viewController: ChecksViewController!

    // MARK: - Instance Methods

    func configure(with viewController: ChecksViewController) {
        let interactor = ChecksInteractor()
        let presenter = ChecksPresenter()
        let router = ChecksRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter

        presenter.viewController = viewController

        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - NSObject

    override func awakeFromNib() {
        super.awakeFromNib()

        self.configure(with: self.viewController)
    }
}
