//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/1/24.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
