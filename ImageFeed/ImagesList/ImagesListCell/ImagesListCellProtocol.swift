//
//  ImagesListCellProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/8/24.
//

import UIKit

protocol ImagesListCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }
    
    var delegate: ImagesListCellDelegate? { get set }
    
    func setupCell(with photo: Photo)
    func setIsLiked(isLiked: Bool)
}
