//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let width: Int?
    let height: Int?
    let likedByUser: Bool?
    let description: String?
    let urls: UrlsResult?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}
