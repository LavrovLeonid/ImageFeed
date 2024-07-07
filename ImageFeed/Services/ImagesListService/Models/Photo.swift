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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    var displayDate: String? {
        guard let createdAt else { return nil }
        
        return dateFormatter.string(from: createdAt)
    }
    
    init(
        id: String,
        size: CGSize,
        createdAt: Date?,
        welcomeDescription: String?,
        thumbImageURL: String,
        largeImageURL: String,
        isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(photoResult: PhotoResult) {
        id = photoResult.id ?? UUID().uuidString
        
        if let width = photoResult.width, let height = photoResult.height {
            size = .init(width: width, height: height)
        } else {
            size = .zero
        }
        
        createdAt = ISO8601DateFormatter().date(from: photoResult.created_at ?? "")
        welcomeDescription = photoResult.description
        isLiked = photoResult.liked_by_user ?? false
        
        thumbImageURL = photoResult.urls?.small ?? ""
        largeImageURL = photoResult.urls?.full ?? ""
    }
}
