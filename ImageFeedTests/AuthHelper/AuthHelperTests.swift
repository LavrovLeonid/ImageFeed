//
//  AuthHelperTests.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/12/24.
//

import XCTest
@testable import ImageFeed

final class AuthHelperTests: XCTestCase {
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url?.absoluteString ?? ""
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        let initialCode = "testing code"
        let url = URL(string: "/oauth/authorize/native?code=\(initialCode)")
        
        //when
        let code = authHelper.code(from: url!)
        
        //then
        XCTAssertEqual(initialCode, code)
    }
}
