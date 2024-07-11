//
//  OAuth2TokenStorageProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

protocol OAuth2TokenStorageProtocol {
    static var shared: OAuth2TokenStorageProtocol { get }
    
    var token: String? { get }
    
    func setToken(token: String)
    func resetToken()
}
