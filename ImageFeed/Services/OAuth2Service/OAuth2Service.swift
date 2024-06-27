//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

final class OAuth2Service: OAuth2ServiceProtocol, Singleton {
    // MARK: Singleton
    static let shared: OAuth2ServiceProtocol = OAuth2Service()
    private init() {}
    
    // MARK: Private properties
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: Methods
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            print("OAuth2Service Error: last auth code not equal current code")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            print("OAuth2Service Error: fail make request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: urlRequest) { 
            [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            completion(result)
            
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: Private methods
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(
            string: "https://unsplash.com/oauth/token"
        ) else {
            assertionFailure("Error initializing URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Error create url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
