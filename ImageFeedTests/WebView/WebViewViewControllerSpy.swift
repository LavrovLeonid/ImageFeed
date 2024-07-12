//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/12/24.
//

import UIKit
@testable import ImageFeed

final class WebViewViewControllerSpy: UIViewController, WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var delegate: WebViewViewControllerDelegate?
    
    var loadCalled: Bool = false
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
