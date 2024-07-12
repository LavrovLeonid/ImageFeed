//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/2/24.
//

import Foundation

enum Constants {
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let accessKey = "3ekPI3owJzuv9cpuLUXdIg077w_tiQaGOfbIj8qZJh4"
    static let secretKey = "HTou8UeyKSr55rJhiq89Nz1yj7i79oQExHUBNFF8Syc"
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultBaseURL: Constants.defaultBaseURL, 
            authURLString: Constants.unsplashAuthorizeURLString
        )
    }
}
