//
//  ProfileLogoutServiceMock.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation
@testable import ImageFeed

final class ProfileLogoutServiceMock: ProfileLogoutServiceProtocol {
    var logoutDidCalled = false
    
    func logout() {
        logoutDidCalled = true
    }
}
