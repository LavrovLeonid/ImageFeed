//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 7/13/24.
//

import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol?
    
    private var imagesListService: ImagesListServiceProtocol?
    private var imageHelper: ImageHelperProtocol?
    
    private(set) var photos: [Photo] = []
    private(set) var selectedPhoto: Photo?
    
    init(
        imagesListService: ImagesListServiceProtocol? = nil,
        notificationCenter: NotificationCenter? = nil,
        imageHelper: ImageHelperProtocol? = nil
    ) {
        self.imagesListService = imagesListService
        self.imageHelper = imageHelper
        
        notificationCenter?.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.updatePhotos()
        }
    }
    
    func viewDidLoad() {
        imagesListService?.fetchPhotosNextPage()
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        
        imagesListService?.fetchPhotosNextPage()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        selectedPhoto = photos[indexPath.row]
        
        viewController?.presentSingleImage()
    }
    
    func cellLikeTapped(at indexPath: IndexPath) {
        guard let imagesListService else { return }
        
        let photo = photos[indexPath.row]
        
        viewController?.showLoader()
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {
            [weak self] result in
            guard let self else { return }
            
            viewController?.dismissLoader()
            
            switch result {
                case .success:
                    photos = imagesListService.photos
                    
                    viewController?.updateCellLike(at: indexPath)
                case .failure:
                    viewController?.showErrorAlert(
                        title: "Что-то пошло не так(",
                        message: "Не удалось изменить избранное"
                    )
            }
        }
    }
    
    func getCellHeight(at indexPath: IndexPath, width: CGFloat, edgeInsets: UIEdgeInsets) -> CGFloat {
        imageHelper?.calcPropotionalHeight(
            by: photos[indexPath.row].size,
            width: width,
            edgeInsets: edgeInsets
        ) ?? .zero
    }
    
    private func updatePhotos() {
        guard let imagesListService, let viewController else { return }
        
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        guard oldCount < newCount else { return }
        
        let indexPaths = (oldCount..<newCount).map { index in
            IndexPath(row: index, section: 0)
        }
        
        viewController.insertTableViewRowsAnimated(at: indexPaths)
    }
}
