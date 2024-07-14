//
//  ImagesListServiceMock.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation
@testable import ImageFeed

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var emulateError: Bool = false
    
    enum TestError: Error {
        case test
    }
    
    func fetchPhotosNextPage() {
        photos += Array(0..<10).map { index in
            Photo(
                id: "\(index)",
                size: .zero,
                createdAt: nil,
                welcomeDescription: nil,
                thumbImageURL: "",
                largeImageURL: "",
                isLiked: false
            )
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if emulateError {
            completion(.failure(TestError.test))
        } else {
            completion(.success(Void()))
        }
    }
}
