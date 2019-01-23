//
//  KeychainManager.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 23/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeychainManager {
    
    // MARK: - Nested Types
    
    fileprivate enum Keys {
        
        // MARK: - Type Properties
        
        static let authToken = "auth_token"
    }
    
    // MARK: - Instance Properties
    
    fileprivate let wrapper = KeychainWrapper.standard
    
    static let shared = KeychainManager()
    
    // MARK: -
    
    var authToken: String? {
        get {
            return self.wrapper.string(forKey: Keys.authToken)
        }
        
        set {
            if let newValue = newValue {
                Log.i(newValue)
                self.wrapper.set(newValue, forKey: Keys.authToken)
            } else {
                Log.i("deleted")
                self.wrapper.removeObject(forKey: Keys.authToken)
            }
        }
    }
}
