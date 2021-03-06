//
//  CacheProvider.swift
//  RoomDebts
//
//  Created by Oleg Gorelov on 08/09/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

protocol CacheProvider {

    // MARK: - Instance Properties

    var isModelCaptured: Bool { get }

    var model: CacheModel { get }

    // MARK: - Instance Methods

    func captureModel() -> Guarantee<CacheSession>
}
