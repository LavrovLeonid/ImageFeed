//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: Private properties
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = .logo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token)
        } else {
            presentAuthenticationViewController()
        }
    }
    
    // MARK: Private methods
    private func setupView() {
        view.backgroundColor = .ypBlack
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func presentAuthenticationViewController() {
        let navigationController = UIStoryboard(
            name: "Main", bundle: .main
        ).instantiateViewController(withIdentifier: "AuthNaviagtionController")
        
        if let navigationController = navigationController as? UINavigationController,
           let authViewController = navigationController.viewControllers.first as? AuthViewController {
            authViewController.delegate = self
        }
        
        present(navigationController, animated: true)
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
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
                case .success(let profile):
                    profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                    
                    switchToTabBarController()
                case .failure:
                    // TODO: Реализовать показ ошибки получения профиля
                    break
            }
        }
    }
}

// MARK: AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewControllerProtocol) {
        guard let token = oAuth2TokenStorage.token else { return }
        
        fetchProfile(token)
    }
}
