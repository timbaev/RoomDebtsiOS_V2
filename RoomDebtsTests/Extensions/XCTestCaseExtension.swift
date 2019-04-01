//
//  XCTestCaseExtension.swift
//  RoomDebtsTests
//
//  Created by Timur Shafigullin on 30/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import XCTest
@testable import RoomDebts

extension XCTestCase {

    // MARK: - Instance Methods

    private func unreachable() -> Never {
        repeat {
            RunLoop.current.run()
        } while (true)
    }

    func expectFatalError(expectedMessage: String = "", testcase: @escaping () -> Void) {
        let expectation = self.expectation(description: "expecting fatalError()")

        var assertionMessage: String?

        FatalErrorUtil.replaceFatalError(closure: { message, file, line in
            assertionMessage = message

            expectation.fulfill()

            self.unreachable()
        })

        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        self.waitForExpectations(timeout: 2, handler: { error in
            XCTAssertEqual(assertionMessage, expectedMessage)

            FatalErrorUtil.restoreFatalError()
        })
    }
}
