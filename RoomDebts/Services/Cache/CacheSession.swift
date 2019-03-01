//
//  CacheSession.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

protocol CacheSession: AnyObject {

    // MARK: - Instance Properties

    var model: CacheModel { get }

    // MARK: - Initializers

    init(model: CacheModel, releaseHandler: @escaping (() -> Void))
}
