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
    
    // MARK: - Type Properties
    
    static let navigationTitle = UIColor(redByte: 63, greenByte: 160, blueByte: 255)
    static let navigationTint = UIColor(redByte: 255, greenByte: 53, blueByte: 0)
    static let white = UIColor(whiteByte: 255)
    
    static let lightGrayBackground = UIColor(whiteByte: 34)
}
