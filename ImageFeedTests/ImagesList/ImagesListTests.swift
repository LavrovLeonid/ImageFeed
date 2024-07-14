//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Леонид Лавров on 7/13/24.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewControllerProtocol
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterFetchImages() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListServiceMock(),
            notificationCenter: notificationCenter
        )
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        //then
        XCTAssertEqual(presenter.photos.count, ImagesListService.pagePhotosCount)
        XCTAssertEqual(viewController.insertIndexPaths.count, ImagesListService.pagePhotosCount)
    }
    
    func testPresenterFetchNextImagesPage() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListServiceMock(),
            notificationCenter: notificationCenter
        )
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        presenter.willDisplayCell(at: IndexPath(row: ImagesListService.pagePhotosCount - 1, section: 0))
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        //then
        XCTAssertEqual(presenter.photos.count, ImagesListService.pagePhotosCount * 2)
        XCTAssertEqual(viewController.insertIndexPaths.count, ImagesListService.pagePhotosCount)
    }
    
    func testPresenterWillNotFetchNextImagesPage() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListServiceMock(),
            notificationCenter: notificationCenter
        )
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        presenter.willDisplayCell(at: IndexPath(row: ImagesListService.pagePhotosCount - 2, section: 0))
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        //then
        XCTAssertEqual(presenter.photos.count, ImagesListService.pagePhotosCount)
    }
    
    func testPresenterTappedCell() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let imageListService = ImagesListServiceMock()
        let notificationCenter = NotificationCenter()
        let presenter = ImagesListPresenter(
            imagesListService: imageListService,
            notificationCenter: notificationCenter
        )
        let photo = Photo(
            id: "0",
            size: .zero,
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        )
        imageListService.photos = [photo]
        
        //when
        viewController.configure(presenter)
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        presenter.didSelectCell(at: IndexPath(row: 0, section: 0))
        
        //then
        XCTAssertEqual(presenter.selectedPhoto, photo)
        XCTAssertTrue(viewController.presentSingleImageDidCalled)
    }
    
    func testPresenterChangeLikeSuccess() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let presenter = ImagesListPresenter(
            imagesListService: ImagesListServiceMock(),
            notificationCenter: notificationCenter
        )
        let likeIndexPath = IndexPath(row: 6, section: 0)
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        presenter.cellLikeTapped(at: likeIndexPath)
        
        //then
        XCTAssertTrue(viewController.showLoaderDidCalled)
        XCTAssertTrue(viewController.dismissLoaderDidCalled)
        XCTAssertEqual(viewController.likeIndexPath, likeIndexPath)
    }
    
    func testPresenterChangeLikeFalture() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let notificationCenter = NotificationCenter()
        let imagesListService = ImagesListServiceMock()
        imagesListService.emulateError = true
        let presenter = ImagesListPresenter(
            imagesListService: imagesListService,
            notificationCenter: notificationCenter
        )
        let likeIndexPath = IndexPath(row: 6, section: 0)
        
        //when
        viewController.configure(presenter)
        presenter.viewDidLoad()
        notificationCenter.post(
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        presenter.cellLikeTapped(at: likeIndexPath)
        
        //then
        XCTAssertTrue(viewController.showLoaderDidCalled)
        XCTAssertTrue(viewController.dismissLoaderDidCalled)
        XCTAssertTrue(viewController.showErrorAlertDidCalled)
    }
}
