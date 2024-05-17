//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/5/24.
//

import UIKit

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    // MARK: Static propertios
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: Outlets
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var gradientView: GradientView! {
        didSet {
            gradientView.clipsToBounds = true
            gradientView.layer.cornerRadius = 16
            gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    // MARK: Public methods
    func setupCell(with dataSource: ImagesListCellDataSource) {
        guard let image = UIImage(named: dataSource.imageName) else { return }
        
        cellImageView.image = image
        dateLabel.text = dataSource.dateText
        likeButton.setImage(
            dataSource.isFavorite ? .favoriteActive : .favoriteNoActive, for: .normal
        )
    }
}
