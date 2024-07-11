//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/4/24.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
    }
    
    // MARK: Private properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService()
    private let notificationCenter = NotificationCenter.default
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.updateTableViewAnimated()
        }
        
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewControllerProtocol,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.setPhoto(photo: photos[indexPath.item])
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        guard oldCount != newCount else { return }
        
        let indexPaths = (oldCount..<newCount).map { index in
            IndexPath(row: index, section: 0)
        }
        
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCellProtocol else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.setupCell(with: photos[indexPath.row])
        
        return imageListCell
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        
        imagesListService.fetchPhotosNextPage()
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {
            [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
                case .success:
                    photos = imagesListService.photos
                    cell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
                case .failure:
                    showErrorAlert(
                        title: "Что-то пошло не так(",
                        message: "Не удалось изменить избранное"
                    )
            }
        }
    }
}
