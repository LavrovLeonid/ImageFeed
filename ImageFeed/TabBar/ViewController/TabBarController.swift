//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/25/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        if let imagesListViewController = imagesListViewController as? ImagesListViewControllerProtocol {
            imagesListViewController.configure(
                ImagesListPresenter(
                    imagesListService: ImagesListService.default,
                    notificationCenter: NotificationCenter.default,
                    imageHelper: ImageHelper()
                )
            )
        }
        
        let profileViewController = ProfileViewController()
        
        profileViewController.configure(
            ProfilePresenter(
                profileService: ProfileService.shared,
                profileImageService: ProfileImageService.shared,
                profileLogoutService: ProfileLogoutService.shared,
                notificationCenter: NotificationCenter.default
            )
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
