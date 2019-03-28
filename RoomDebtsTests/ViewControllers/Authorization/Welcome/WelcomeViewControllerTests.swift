//
//  WelcomViewControllerTests.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 27/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit
import XCTest
@testable import RoomDebts

class WelcomeViewControllerTests: XCTestCase {

    // MARK: - Instance Properties

    var sut: WelcomeViewController!
    var window: UIWindow!

    // MARK: - Instance Methods

    private func setupWelcomeViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Welcome", bundle: bundle)

        let initialViewController = storyboard.instantiateInitialViewController()

        if let navigationController = initialViewController as? UINavigationController {
            self.sut = navigationController.viewControllers.first as? WelcomeViewController
        } else {
            self.sut = initialViewController as? WelcomeViewController
        }
    }

    private func loadView() {
        self.window.addSubview(self.sut.view)

        RunLoop.current.run(until: Date())
    }

    // MARK: -

    func testClearCoreData() {
        // arrange
        Services.cacheProvider = MockCacheProvider()

        let viewContext = Services.cacheProvider.model.viewContext as! MockCacheContext

        // act
        self.loadView()

        // assert
        XCTAssertTrue(viewContext.clearCalled)
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        self.window = UIWindow()

        self.setupWelcomeViewController()
    }

    override func tearDown() {
        self.window = nil

        super.tearDown()
    }
}
