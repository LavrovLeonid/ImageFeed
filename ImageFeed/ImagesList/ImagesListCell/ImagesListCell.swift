//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/5/24.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    // MARK: Static propertios
    static let reuseIdentifier = "ImagesListCell"
    
    private weak var delegate: ImagesListCellDelegate?
    
    // MARK: Outlets
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton! {
        didSet {
            likeButton.accessibilityIdentifier = "like button"
        }
    }
    @IBOutlet private weak var gradientView: GradientView! {
        didSet {
            gradientView.clipsToBounds = true
            gradientView.layer.cornerRadius = 16
            gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImageView.kf.cancelDownloadTask()
    }
    
    // MARK: Public methods
    func setupCell(with photo: Photo, delegate: ImagesListCellDelegate) {
        self.delegate = delegate
        
        if let placeholderImageData = UIImage(resource: .imageLoader).pngData() {
            cellImageView.kf.indicatorType = .image(imageData: placeholderImageData)
        }
        
        cellImageView.kf.setImage(with: URL(string: photo.thumbImageURL))
        
        dateLabel.text = photo.displayDate
        
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked: Bool) {
        likeButton.setImage(isLiked ? .favoriteActive : .favoriteNoActive, for: .normal)
    }
    
    @IBAction private func likeButtonTapped() {
        delegate?.imageListCellDidTapLike(self)
    }
}
