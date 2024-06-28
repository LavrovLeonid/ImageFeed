//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/18/24.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    )
}
