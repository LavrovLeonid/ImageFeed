//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    var selectedPhoto: Photo? { get }
    
    func viewDidLoad()
    func didSelectCell(at indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func cellLikeTapped(at indexPath: IndexPath)
    func getCellHeight(at indexPath: IndexPath, width: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat
}
