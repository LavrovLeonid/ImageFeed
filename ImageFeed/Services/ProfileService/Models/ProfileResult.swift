//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/17/24.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String?
    let first_name: String?
    let last_name: String?
    let bio: String?
}
