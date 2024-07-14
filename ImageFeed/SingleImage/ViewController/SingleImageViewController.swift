//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/17/24.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController, SingleImageViewControllerProtocol {
    // MARK: Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.accessibilityIdentifier = "nav back button"
        }
    }
    
    // MARK: Private properties
    private var photo: Photo? {
        didSet {
            guard isViewLoaded else { return }
            
            setupImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setupImage()
    }
    
    @IBAction private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @IBAction private func sharedButtonTapped() {
        guard let image = imageView.image else { return }
        
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(share, animated: true)
    }
    
    // MARK: Properties
    func setPhoto(photo: Photo) {
        self.photo = photo
    }
    
    // MARK: Private properties
    private func setupImage() {
        guard let photo, let photoURL = URL(string: photo.largeImageURL) else { return }
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: photoURL, placeholder: UIImage(resource: .imageLoader)) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
                case .success(let imageResult):
                    imageView.frame.size = imageResult.image.size
                    rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Не надо", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.setupImage()
        })
        
        present(alertController, animated: true)
    }
}

// MARK: UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
