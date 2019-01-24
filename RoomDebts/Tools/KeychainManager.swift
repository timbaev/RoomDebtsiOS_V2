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
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let expiredAt = "expired_at"
    }
    
    // MARK: - Instance Properties
    
    fileprivate let wrapper = KeychainWrapper.standard
    
    static let shared = KeychainManager()
    
    // MARK: -
    
    var access: Access? {
        get {
            guard let accessToken = self.wrapper.string(forKey: Keys.accessToken) else {
                return nil
            }
            
            guard let refreshToken = self.wrapper.string(forKey: Keys.refreshToken) else {
                return nil
            }
            
            guard let expiredAt = self.wrapper.object(forKey: Keys.expiredAt) as? Date else {
                return nil
            }
            
            return Access(accessToken: accessToken, refreshToken: refreshToken, expiredAt: expiredAt)
        }
        
        set {
            if let newValue = newValue {
                Log.i(newValue.accessToken)
                self.wrapper.set(newValue.accessToken, forKey: Keys.accessToken)
                self.wrapper.set(newValue.refreshToken, forKey: Keys.refreshToken)
                self.wrapper.set(NSDate(timeIntervalSince1970: newValue.expiredAt.timeIntervalSince1970), forKey: Keys.expiredAt)
            } else {
                Log.i("deleted")
                self.wrapper.removeObject(forKey: Keys.accessToken)
                self.wrapper.removeObject(forKey: Keys.refreshToken)
                self.wrapper.removeObject(forKey: Keys.expiredAt)
            }
        }
    }
    
    // MARK: - Instance Properties
    
    func clear() {
        self.wrapper.removeAllKeys()
    }
}
