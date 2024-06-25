//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/3/24.
//

import UIKit

final class AuthViewController: UIViewController, AuthViewControllerProtocol {
    // MARK: Private properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oAuth2Service: OAuth2ServiceProtocol = OAuth2Service.shared
    private let oAuth2TokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    
    // MARK: Properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: Overrides
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let viewController = segue.destination as? WebViewViewControllerProtocol
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}

// MARK: WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(
        _ vc: WebViewViewControllerProtocol,
        didAuthenticateWithCode code: String
    ) {
        navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
                case .success(let data):
                    oAuth2TokenStorage.setToken(token: data.accessToken)
                    delegate?.didAuthenticate(self)
                case .failure(_):
                    showErrorAlert(
                        title: "Что-то пошло не так(",
                        message: "Не удалось войти в систему"
                    )
            }
        }
    }
    
    func webViewViewControllerDidCancel(
        _ vc: WebViewViewControllerProtocol
    ) {
        navigationController?.popViewController(animated: true)
    }
}
