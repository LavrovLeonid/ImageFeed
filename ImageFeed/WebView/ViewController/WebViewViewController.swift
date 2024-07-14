//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit
import WebKit

final class WebViewViewController:
    UIViewController, WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            webView.accessibilityIdentifier = "UnsplashWebView"
        }
    }
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] webView, _ in
                 self?.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             }
        )
    }
    
    func configure(_ presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.viewController = self
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        
        return nil
    }
    
    @IBAction private func backButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow)
        }
    }
}
