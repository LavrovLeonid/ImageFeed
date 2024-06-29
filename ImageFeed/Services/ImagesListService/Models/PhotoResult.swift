//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/28/24.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let width: Int?
    let height: Int?
    let liked_by_user: Bool?
    let description: String?
    let urls: UrlsResult?
}
