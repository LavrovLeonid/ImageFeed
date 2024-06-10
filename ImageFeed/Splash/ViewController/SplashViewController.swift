//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: Private properties
    private let oAuth2Storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthentificationScreen"
    private let showMainScreenSegueIdentifier = "ShowMainScreen"
    
    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oAuth2Storage.token == nil {
            presentAuthenticationViewController()
        } else {
            switchToTabBarController()
        }
    }
    
    // MARK: Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewControllerProtocol
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: Private methods
    private func presentAuthenticationViewController() {
        performSegue(
            withIdentifier: showAuthenticationScreenSegueIdentifier,
            sender: nil
        )
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(
            name: "Main", bundle: .main
        ).instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

// MARK: AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewControllerProtocol) {
        switchToTabBarController()
    }
}
