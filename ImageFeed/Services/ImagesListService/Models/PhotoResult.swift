//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String?
    let created_at: Date?
    let updated_at: Date?
    let width: Int?
    let height: Int?
    let liked_by_user: Bool?
    let description: String?
    let urls: UrlsResult?
}
