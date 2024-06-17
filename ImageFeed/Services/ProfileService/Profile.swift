//
//  Profile.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/17/24.
//

import Foundation

struct Profile {
    let name: String
    let login: String
    let bio: String
    
    init(profileResult: ProfileResult) {
        if let username = profileResult.username {
            login = "@\(username)"
        } else {
            login = ""
        }
        
        name = "\(profileResult.first_name ?? "") \(profileResult.last_name ?? "")"
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        bio = profileResult.bio ?? ""
    }
}
