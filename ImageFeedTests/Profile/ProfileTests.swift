//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        //when
        viewController.configure(presenter)
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsSetupView() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.setupViewDidCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileCervice = ProfileServiceMock()
        let presenter = ProfilePresenter(
            profileService: profileCervice
        )
        
        //when
        profileCervice.fetchProfile("") { _ in }
        viewController.configure(presenter)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsDidCalled)
    }
    
    func testPresenterCallsSetupImage() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileImageService = ProfileImageServiceMock()
        let presenter = ProfilePresenter(
            profileImageService: profileImageService
        )
        
        //when
        profileImageService.fetchProfileImageURL(username: "") { _ in }
        viewController.configure(presenter)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.setupImageDidCalled)
    }
    
    func testPresenterCallsSetupImageFromNotification() {
        //given
        let viewController = ProfileViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let presenter = ProfilePresenter(
            notificationCenter: notificationCenter
        )
        
        //when
        _ = viewController.view
        viewController.configure(presenter)
        notificationCenter.post(
            name: ProfileImageService.didChangeNotification,
            object: nil,
            userInfo: [ProfileImageService.profileAvatarKey: "http://test"]
        )
        
        //then
        XCTAssertTrue(viewController.setupImageDidCalled)
    }
    
    func testPresenterCallsShowExitAlert() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        
        //when
        viewController.configure(presenter)
        presenter.exitButtonTapped()
        
        //then
        XCTAssertTrue(viewController.showExitAlertCalled)
    }
    
    func testPresenterLogout() {
        //given
        let profileLogoutService = ProfileLogoutServiceMock()
        let presenter = ProfilePresenter(
            profileLogoutService: profileLogoutService
        )
        
        //when
        presenter.logoutProfile()
        
        //then
        XCTAssertTrue(profileLogoutService.logoutDidCalled)
    }
}
