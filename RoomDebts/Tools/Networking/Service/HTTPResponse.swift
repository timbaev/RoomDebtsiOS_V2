//
//  HTTPResponse.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct HTTPResponse<Content> {

    // MARK: - Instance Properties

    let content: Content
    let httpStatusCode: HTTPStatusCode
}
