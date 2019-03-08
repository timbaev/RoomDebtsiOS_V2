//
//  Colors.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 20/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum Colors {

    // MARK: - Nested Types

    enum TabBarGradient {

        // MARK: - Type Properties

        static let first = UIColor(redByte: 38, greenByte: 39, blueByte: 61)
        static let second = UIColor(redByte: 37, greenByte: 37, blueByte: 70)
    }

    // MARK: -

    enum PrimaryButton {

        // MARK: - Type Properties

        static let first = UIColor(redByte: 29, greenByte: 9, blueByte: 215)
        static let second = UIColor(redByte: 216, greenByte: 20, blueByte: 188)
        static let third = UIColor(redByte: 190, greenByte: 30, blueByte: 216)
    }

    // MARK: -

    enum Search {

        // MARK: - Type Properties

        static let first = UIColor(redByte: 0, greenByte: 218, blueByte: 255)
        static let second = UIColor(redByte: 115, greenByte: 0, blueByte: 255)
    }

    // MARK: -

    enum Background {

        // MARK: - Type Properties

        static let first = UIColor(redByte: 23, greenByte: 24, blueByte: 58)
        static let second = UIColor(redByte: 17, greenByte: 56, blueByte: 108)
    }

    // MARK: -

    enum Border {

        // MARK: - Type Properties

        static let first = UIColor(redByte: 255, greenByte: 0, blueByte: 184)
        static let second = UIColor(redByte: 255, greenByte: 196, blueByte: 0)
    }

    // MARK: - Type Properties

    static let navigationTitle = UIColor(redByte: 63, greenByte: 160, blueByte: 255)
    static let navigationTint = UIColor(redByte: 255, greenByte: 53, blueByte: 0)

    static let white = UIColor(whiteByte: 255)
    static let black = UIColor.black
    static let dark = UIColor(redByte: 20, greenByte: 45, blueByte: 68)

    static let lightGrayBackground = UIColor(whiteByte: 34)

    static let emptyState = UIColor(redByte: 7, greenByte: 16, blueByte: 60)

    static let red = UIColor(redByte: 255, greenByte: 3, blueByte: 3)
    static let green = UIColor(redByte: 3, greenByte: 255, blueByte: 23)
    static let gray = UIColor(redByte: 155, greenByte: 155, blueByte: 155)

    static let barItem = UIColor(redByte: 153, greenByte: 55, blueByte: 123)

    static let clear = UIColor.clear

    static let placeholder = UIColor(redByte: 170, greenByte: 170, blueByte: 170)
    static let textPlaceholder = UIColor(redByte: 255, greenByte: 255, blueByte: 255, alpha: 0.6)
}
