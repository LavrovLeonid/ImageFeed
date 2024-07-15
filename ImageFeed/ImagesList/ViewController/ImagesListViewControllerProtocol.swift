//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

protocol ImagesListViewControllerProtocol: UIViewController {
    var presenter: ImagesListPresenterProtocol? { get }
    
    func configure(_ presenter: ImagesListPresenterProtocol)
    func updateCellLike(at indexPath: IndexPath)
    func showErrorAlert(title: String, message: String)
    func insertTableViewRowsAnimated(at indexPaths: [IndexPath])
    func presentSingleImage()
    func showLoader()
    func dismissLoader()
}
