//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(
        _ vc: WebViewViewControllerProtocol,
        didAuthenticateWithCode code: String
    )
    func webViewViewControllerDidCancel(
        _ vc: WebViewViewControllerProtocol
    )
}
