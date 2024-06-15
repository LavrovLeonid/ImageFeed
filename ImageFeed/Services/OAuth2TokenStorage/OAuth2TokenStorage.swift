//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol, Singleton {
    // MARK: Singleton
    static let shared: OAuth2TokenStorageProtocol = OAuth2TokenStorage()
    private init() {}
    
    // MARK: Private protperties
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
    
    // MARK: Protperties
    var token: String? {
        get {
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode(
                    String.self, from: data
                  ) else {
                return nil
            }
            
            return token
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Error encode token")
                return
            }
            
            userDefaults.set(data, forKey: Keys.token.rawValue)
        }
    }
    
    // MARK: Methods
    func setToken(token: String) {
        self.token = token
    }
}
