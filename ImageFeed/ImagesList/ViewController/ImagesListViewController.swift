//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/4/24.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
    }
    
    // MARK: Private properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let cellEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    private(set) var presenter: ImagesListPresenterProtocol?
    private var photos: [Photo] {
        presenter?.photos ?? []
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewControllerProtocol,
                let photo = presenter?.selectedPhoto
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.setPhoto(photo: photo)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.viewController = self
    }
    
    func insertTableViewRowsAnimated(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func updateCellLike(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ImagesListCellProtocol
        
        cell?.setIsLiked(isLiked: photos[indexPath.row].isLiked)
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
    
    func presentSingleImage() {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: nil)
    }
    
    func showLoader() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissLoader() {
        UIBlockingProgressHUD.dismiss()
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
        
        imageListCell.setupCell(with: photos[indexPath.row], delegate: self)
        
        return imageListCell
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.getCellHeight(
            at: indexPath,
            width: tableView.bounds.width,
            edgeInsets: cellEdgeInsets
        ) ?? .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath)
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.cellLikeTapped(at: indexPath)
    }
}
