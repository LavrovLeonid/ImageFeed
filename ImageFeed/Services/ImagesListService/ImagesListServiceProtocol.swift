//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage()
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Void, Error>
        ) -> Void)
}
