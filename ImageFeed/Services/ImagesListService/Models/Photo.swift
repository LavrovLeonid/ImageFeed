//
//  Photo.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    var displayDate: String? {
        guard let createdAt else { return nil }
        
        return Photo.dateFormatter.string(from: createdAt)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}
