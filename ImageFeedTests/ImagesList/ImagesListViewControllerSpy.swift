//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit
@testable import ImageFeed

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var insertIndexPaths: [IndexPath] = []
    var likeIndexPath: IndexPath?
    
    var showLoaderDidCalled = false
    var dismissLoaderDidCalled = false
    var presentSingleImageDidCalled = false
    var showErrorAlertDidCalled = false
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.viewController = self
    }
    
    func updateCellLike(at indexPath: IndexPath) {
        likeIndexPath = indexPath
    }
    
    func showErrorAlert(title: String, message: String) {
        showErrorAlertDidCalled = true
    }
    
    func insertTableViewRowsAnimated(at indexPaths: [IndexPath]) {
        insertIndexPaths = indexPaths
    }
    
    func presentSingleImage() {
        presentSingleImageDidCalled = true
    }
    
    func showLoader() {
        showLoaderDidCalled = true
    }
    
    func dismissLoader() {
        dismissLoaderDidCalled = true
    }
}
