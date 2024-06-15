//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit

protocol WebViewViewControllerProtocol: UIViewController {
    var delegate: WebViewViewControllerDelegate? { get set }
}
