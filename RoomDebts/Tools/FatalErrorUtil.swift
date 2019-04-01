//
//  FatalErrorUtil.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 30/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

struct FatalErrorUtil {

    // MARK: - Type Properties

    private static let defaultFatalErrorClosure = {
        Swift.fatalError($0, file: $1, line: $2)
    }

    // MARK: -

    static var fatalErrorClosure: (String, StaticString, UInt) -> Never = FatalErrorUtil.defaultFatalErrorClosure

    // MARK: - Type Methods

    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
        FatalErrorUtil.fatalErrorClosure = closure
    }

    static func restoreFatalError() {
        FatalErrorUtil.fatalErrorClosure = defaultFatalErrorClosure
    }
}
