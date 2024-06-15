//
//  AuthViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 6/9/24.
//

import UIKit

protocol AuthViewControllerProtocol: UIViewController {
    var delegate: AuthViewControllerDelegate? { get set }
}
