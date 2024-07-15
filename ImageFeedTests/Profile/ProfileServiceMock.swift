//
//  ProfileServiceMock.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation
@testable import ImageFeed

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
         profile = .init(username: "test user name", name: "test name", login: "test login", bio: "test bio")
    }
    
    func resetProfile() {
        profile = nil
    }
}
