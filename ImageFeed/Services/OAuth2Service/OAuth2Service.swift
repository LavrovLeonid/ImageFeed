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
    
    // MARK: Methods
    func fetchOAuthToken(
        code: String,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            return
        }
        
        let task = urlSession.data(for: urlRequest) { result in
            switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        
                        let response = try decoder.decode(
                            OAuthTokenResponseBody.self,
                            from: data
                        )
                        
                        completion(.success(response))
                    } catch {
                        print("Decoding error")
                        completion(.failure(OAuth2ServiceError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
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
