//
//  DefaultConfirmCoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 24/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import Gloss

struct DefaultConfirmCoder: ConfirmCoder {
    
    // MARK: - Nested Types
    
    fileprivate enum JSONKeys {
        
        // MARK: - Type Properties
        
        static let code = "code"
    }
    
    // MARK: - Instance Methods
    
    func encode(code: String) -> JSON {
        return [JSONKeys.code: code]
    }
}
