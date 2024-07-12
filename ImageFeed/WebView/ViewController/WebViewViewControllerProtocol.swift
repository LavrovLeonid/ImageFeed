//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit

protocol WebViewViewControllerProtocol: UIViewController {
    var presenter: WebViewPresenterProtocol? { get set }
    var delegate: WebViewViewControllerDelegate? { get set }
    
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
