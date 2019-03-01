//
//  Fonts.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum Fonts {

    // MARK: - Type Methods

    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Regular", size: size)!
    }

    static func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size)!
    }

    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Black", size: size)!
    }

    static func semibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Bold", size: size)!
    }

    static func light(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Light", size: size)!
    }
}
