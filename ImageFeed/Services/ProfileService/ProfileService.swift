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
            print("ProfileService Error: last token not equal current token")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let urlRequest = makeProfileRequest(token) else {
            print("ProfileService Error: fail make request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: urlRequest) { 
            [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
                case .success(let data):
                    let profile = Profile(profileResult: data)
                    
                    self?.profile = profile
                    
                    completion(.success(profile))
                case .failure(let error):
                    print(
                        "ProfileService Error: fail request with error ",
                        error.localizedDescription
                    )
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
