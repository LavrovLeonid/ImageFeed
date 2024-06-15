//
//  OAuth2ServiceProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

protocol OAuth2ServiceProtocol {
    static var shared: OAuth2ServiceProtocol { get }
    
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    )
}
