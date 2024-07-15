//
//  ProfileImageServiceMock.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation
@testable import ImageFeed

final class ProfileImageServiceMock: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        avatarURL = "https://test"
    }
    
    func resetProfileImage() {
        
    }
}
