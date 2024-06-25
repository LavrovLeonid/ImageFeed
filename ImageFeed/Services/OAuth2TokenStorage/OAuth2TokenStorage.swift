//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol, Singleton {
    // MARK: Singleton
    static let shared: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private init() {}
    
    // MARK: Private protperties
    private let keychainWrapper = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    
    // MARK: Protperties
    var token: String? {
        get {
            guard let token = keychainWrapper.string(forKey: Keys.token.rawValue) else {
                return nil
            }
            
            return token
        }
        set {
            guard let newValue else {
                keychainWrapper.removeObject(forKey: Keys.token.rawValue)
                return
            }
            
            keychainWrapper.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    // MARK: Methods
    func setToken(token: String) {
        self.token = token
    }
}
