//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var viewController: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func exitButtonTapped() {
        
    }
    
    func logoutProfile() {
        
    }
}
