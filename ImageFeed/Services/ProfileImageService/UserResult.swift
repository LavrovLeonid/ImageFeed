//
//  UserResult.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/18/24.
//

import Foundation

struct UserResult: Decodable {
    let profile_image: ProfileImage?
    
    struct ProfileImage: Decodable {
        let small: String?
    }
}
