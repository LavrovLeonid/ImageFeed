//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var setupViewDidCalled = false
    var updateProfileDetailsDidCalled = false
    var setupImageDidCalled = false
    var showExitAlertCalled = false
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.viewController = self
    }
    
    func setupView() {
        setupViewDidCalled = true
    }
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsDidCalled = true
    }
    
    func setupImage(url: URL) {
        setupImageDidCalled = true
    }
    
    func showExitAlert() {
        showExitAlertCalled = true
    }
}

