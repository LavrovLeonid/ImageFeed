//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import Foundation

protocol ProfilePresenterProtocol {
    var viewController: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func exitButtonTapped()
    func logoutProfile()
}
