//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/18/24.
//

import Foundation

final class ProfileImageService: ProfileImageServiceProtocol, Singleton {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static var shared: ProfileImageServiceProtocol = ProfileImageService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let notificationService = NotificationCenter.default
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        
        guard lastUsername != username else {
            print("ProfileImageService Error: last username not equal current username")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastUsername = username
        
        guard let urlRequest = makeProfileImageURLRequest(username: username) else {
            print("ProfileImageService Error: fail make request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: urlRequest) {
            [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
                case .success(let data):
                    if let avatarURL = data.profile_image?.small {
                        self.avatarURL = avatarURL
                        completion(.success(avatarURL))
                        
                        notificationService.post(
                            name: Self.didChangeNotification,
                            object: self,
                            userInfo: ["URL": avatarURL]
                        )
                    } else {
                        print(
                            "ProfileImageService Error: not found image ",
                            data
                        )
                        completion(.failure(NetworkError.decodingError))
                    }
                case .failure(let error):
                    print(
                        "ProfileImageService Error: fail request with error ",
                        error.localizedDescription
                    )
                    completion(.failure(error))
            }
            
            self.task = nil
            self.lastUsername = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: Private methods
    private func makeProfileImageURLRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(username)", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error initializing Profile URL")
            return nil
        }
        
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("Token not found")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
