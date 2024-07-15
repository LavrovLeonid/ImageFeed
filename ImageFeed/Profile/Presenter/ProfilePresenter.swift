//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    
    private var profileService: ProfileServiceProtocol?
    private var profileImageService: ProfileImageServiceProtocol?
    private var profileLogoutService: ProfileLogoutServiceProtocol?
    
    init(
        profileService: ProfileServiceProtocol? = nil,
        profileImageService: ProfileImageServiceProtocol? = nil,
        profileLogoutService: ProfileLogoutServiceProtocol? = nil,
        notificationCenter: NotificationCenter? = nil
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
        
        notificationCenter?.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let self,
                let viewController,
                viewController.isViewLoaded,
                let userInfo = notification.userInfo,
                let avatarURL = userInfo[ProfileImageService.profileAvatarKey] as? String,
                let url = URL(string: avatarURL)
            else { return }
            
            viewController.setupImage(url: url)
        }
    }
    
    func viewDidLoad() {
        guard let viewController else { return }
        
        viewController.setupView()
        
        if let profile = profileService?.profile {
            viewController.updateProfileDetails(profile: profile)
        }
        
        if let avatarURL = profileImageService?.avatarURL,
           let url = URL(string: avatarURL) {
            viewController.setupImage(url: url)
        }
    }
    
    func exitButtonTapped() {
        viewController?.showExitAlert()
    }
    
    func logoutProfile() {
        profileLogoutService?.logout()
    }
}
