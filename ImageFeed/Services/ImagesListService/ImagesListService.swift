//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private var lastTask: URLSessionTask?
    
    private let perPage = 10
    private let urlSession = URLSession.shared
    private let notificationService = NotificationCenter.default
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage + 1
        
        guard lastTask == nil else {
            print("ImagesListService Error: photos already requested")
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            print("ImagesListService Error: not found token")
            return
        }
        
        guard let urlRequest = makePhotosURLRequest(
            page: nextPage,
            perPage: perPage,
            token: token
        ) else {
            print("ImagesListService Error: fail make request")
            return
        }
        
        let task = urlSession.objectTask(for: urlRequest) { 
            [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
                case .success(let photoResults):
                    let photos = photoResults.map { photoResult in
                        var size: CGSize
                        
                        if let width = photoResult.width, let height = photoResult.height {
                            size = .init(width: width, height: height)
                        } else {
                            size = .zero
                        }
                        
                        return Photo(
                            id: photoResult.id ?? UUID().uuidString,
                            size: size,
                            createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls?.small ?? "",
                            largeImageURL: photoResult.urls?.full ?? "",
                            isLiked: photoResult.likedByUser ?? false
                        )
                    }
                    
                    self?.lastLoadedPage += 1
                    self?.photos += photos
                    
                    self?.notificationService.post(
                        name: Self.didChangeNotification,
                        object: self
                    )
                case .failure(let error):
                    print(
                        "ImagesListService Error: fail request with error ",
                        error.localizedDescription
                    )
            }
            
            self?.lastTask = nil
        }
        
        lastTask = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>
        ) -> Void) {
        guard let token = oAuth2TokenStorage.token else {
            print("ImagesListService Error: not found token")
            return
        }
        
        guard let urlRequest = makePhotosLikeURLRequest(
            photoId: photoId,
            isLike: isLike,
            token: token
        ) else {
            print("ImagesListService Error: fail make request")
            return
        }
        
        let task = urlSession.data(for: urlRequest) { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .success:
                    if let index = photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = photos[index]
                        
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        
                        self.photos[index] = newPhoto
                    }
                    completion(.success(Void()))
                case .failure(let error):
                    print(
                        "ImagesListService Error: fail request with error ",
                        error.localizedDescription
                    )
                    completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makePhotosURLRequest(page: Int, perPage: Int, token: String) -> URLRequest? {
        guard let url = URL(string: "/photos", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error initializing Photos URL")
            return nil
        }
        
        guard var urlComponents = URLComponents(
            url: url, resolvingAgainstBaseURL: true
        ) else {
            assertionFailure("Error initializing Photos URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Error create Photos URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func makePhotosLikeURLRequest(photoId: String, isLike: Bool, token: String) -> URLRequest? {
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error initializing Photos URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = isLike ? "DELETE" : "POST"
        
        return request
    }
}
