//
//  ImagesListCellProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/8/24.
//

import UIKit

protocol ImagesListCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }
    
    func setupCell(with photo: Photo, delegate: ImagesListCellDelegate)
    func setIsLiked(isLiked: Bool)
}
