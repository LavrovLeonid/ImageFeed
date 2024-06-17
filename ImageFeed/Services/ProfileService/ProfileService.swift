//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/17/24.
//

import Foundation

final class ProfileService: ProfileSereviceProtocol, Singleton {
    // MARK: Singleton
    static var shared: ProfileSereviceProtocol = ProfileService()
    private init() {}
    
    // MARK: Properties
    private(set) var profile: Profile?
    
    // MARK: Private properties
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    // MARK: Methods
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard lastToken != token else {
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let urlRequest = makeProfileRequest(token) else {
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: urlRequest) { [weak self] result in
            switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        
                        let response = try decoder.decode(
                            ProfileResult.self,
                            from: data
                        )
                        let profile = Profile(profileResult: response)
                        
                        self?.profile = profile
                        
                        completion(.success(profile))
                    } catch {
                        print("Decoding error")
                        completion(.failure(OAuth2ServiceError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastToken = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: Private methods
    private func makeProfileRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error initializing Profile URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
