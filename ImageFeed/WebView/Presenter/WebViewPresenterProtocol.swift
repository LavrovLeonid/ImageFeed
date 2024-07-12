//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/11/24.
//

import Foundation

protocol WebViewPresenterProtocol {
    var viewController: WebViewViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
