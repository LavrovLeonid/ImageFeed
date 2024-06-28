//
//  Photo.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        id = photoResult.id ?? UUID().uuidString
        
        if let width = photoResult.width, let height = photoResult.height {
            size = .init(width: width, height: height)
        } else {
            size = .zero
        }
        
        createdAt = photoResult.created_at
        welcomeDescription = photoResult.description
        isLiked = photoResult.liked_by_user ?? false
        
        thumbImageURL = photoResult.urls?.thumb ?? ""
        largeImageURL = photoResult.urls?.full ?? ""
    }
}
