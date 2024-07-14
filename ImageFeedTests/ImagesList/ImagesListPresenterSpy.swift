//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var selectedPhoto: Photo?
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        
    }
    
    func cellLikeTapped(at indexPath: IndexPath) {
        
    }
    
    func getCellHeight(at indexPath: IndexPath, width: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat {
        .zero
    }
}
