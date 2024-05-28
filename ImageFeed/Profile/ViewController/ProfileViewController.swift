//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/17/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        let profileImageView = createProfileImageView()
        let exitButton = createExitButton()
        
        let descriptionStackView = createDescriptionStackView()
        
        let nameLabel = createNameLabel()
        let nicknameLabel = createNicknameLabel()
        let descriptionLabel = createDescriptionLabel()
        
        descriptionStackView.addArrangedSubview(nameLabel)
        descriptionStackView.addArrangedSubview(nicknameLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        
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
    
    private func createProfileImageView() -> UIImageView {
        let imageView = UIImageView(
            image: UIImage(resource: .avatar)
        )
        
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func createExitButton() -> UIButton {
        let button = UIButton.systemButton(
            with: UIImage(resource: .exit),
            target: self,
            action: nil
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        
        return button
    }
    
    private func createDescriptionStackView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }
    
    private func createNameLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        
        return label
    }
    
    private func createNicknameLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@ekaterina_nov"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .ypGray
        
        return label
    }
    
    private func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .ypWhite
        
        return label
    }
}