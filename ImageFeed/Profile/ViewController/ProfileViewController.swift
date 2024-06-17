//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/17/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: Private properties
    private let profileService = ProfileService.shared
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(resource: .avatar)
        )
        
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(resource: .exit),
            target: self,
            action: nil
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        
        return button
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .ypGray
        
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .ypWhite
        label.numberOfLines = 0
        
        return label
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: Private methods
    private func setupView() {
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        descriptionStackView.addArrangedSubview(nameLabel)
        descriptionStackView.addArrangedSubview(loginLabel)
        descriptionStackView.addArrangedSubview(bioLabel)
        
        view.addSubview(profileImageView)
        view.addSubview(exitButton)
        view.addSubview(descriptionStackView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            profileImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            
            exitButton.widthAnchor.constraint(equalToConstant: 42),
            exitButton.heightAnchor.constraint(equalToConstant: 42),
            exitButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            descriptionStackView.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: 8
            ),
            descriptionStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            descriptionStackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            )
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginLabel.text = profile.login
        bioLabel.text = profile.bio
    }
}
