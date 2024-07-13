//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

protocol ProfileViewControllerProtocol: UIViewController {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func configure(_ presenter: ProfilePresenterProtocol)
    func setupView()
    func updateProfileDetails(profile: Profile)
    func setupImage(url: URL)
    func showExitAlert()
}
