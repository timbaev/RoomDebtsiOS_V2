//
//  CheckExtractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

protocol CheckExtractor {

    // MARK: - Instance Methods

    func extractCheck(from json: JSON) -> Promise<Check>
    func extractCheckList(from json: [JSON], withListType listType: CheckListType) -> Promise<CheckList>
}
