//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/6/24.
//

import Foundation
import WebKit

final class ProfileLogoutService: Singleton, ProfileLogoutServiceProtocol {
    static let shared: ProfileLogoutServiceProtocol = ProfileLogoutService()
    
    private let httpCookieStorage = HTTPCookieStorage.shared
    private let wkWebsiteDataStore = WKWebsiteDataStore.default()
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanToken()
        cleanProfile()
        
        switchToSplashViewController()
    }
    
    private func cleanCookies() {
        httpCookieStorage.removeCookies(since: Date.distantPast)
        
        wkWebsiteDataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { [weak self] records in
            records.forEach { record in
                self?.wkWebsiteDataStore.removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    private func cleanToken() {
        oAuth2TokenStorage.resetToken()
    }
    
    private func cleanProfile() {
        profileService.resetProfile()
        profileImageService.resetProfileImage()
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}

