//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Леонид Лавров on 7/14/24.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("<логин>")
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 2))
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("<пароль>")
        
        XCTAssertTrue(webView.waitForExistence(timeout: 2))
        app.toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(2)
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)
        
        cellToLike.buttons["like button"].tap()
        
        sleep(2)
        
        cellToLike.buttons["like button"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(2)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Leonid Lavrov"].exists)
        XCTAssertTrue(app.staticTexts["@leonidlavrov"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["logOutAlert"].scrollViews.otherElements.buttons["Yes"].tap()
        
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
