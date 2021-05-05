//
//  PhotoViewModel.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

protocol PhotoListViewModelDelegate: AnyObject {
    func reload()
    func show(error: AppError)
}

class PhotoViewModel {
    private let router = Router<PhotoAPI>()
    private var dataSource = [PhotoProtocol]() {
        didSet {
            self.delegate?.reload()
        }
    }
    private var operations: PendingOperations
    weak var delegate: PhotoListViewModelDelegate?
    
    init(delegate: PhotoListViewModelDelegate, operations: PendingOperations = PendingOperations()) {
        self.operations = operations
        self.delegate = delegate
    }
    
    func fetchPhotoDetails() {
        self.router.request(PhotoAPI.list) { [weak self] (result: Result<[Photo], AppError>) in
            switch result {
            case .success(let photos):
                self?.dataSource = photos.compactMap { PhotoCellViewModel(photo: $0) }
                
            case .failure(let error):
                self?.delegate?.show(error: error)
            }
        }
    }
    func numberOfRows() -> Int {
        self.dataSource.count
    }
    func photo(at index: Int) -> PhotoProtocol {
        self.dataSource[index]
    }
    func configureCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let photo = self.photo(at: indexPath.row)
        cell.photo = photo
        self.checkOperation(for: photo, at: indexPath, in: tableView)
        return cell
    }
    func suspendResumeAllOperations(isSuspended: Bool) {
        operations.suspendResumeAllOperations(isSuspended: isSuspended)
    }
    func performOperationForOnScreenCells(in tableView: UITableView) {
        // Getting on screen cells
        if let visibleIndexPathArray = tableView.indexPathsForVisibleRows {
            var allPendingOperation = Set(operations.downloadInProgress.keys)
            allPendingOperation.formUnion(operations.filterInProgress.keys)
            // Determining Operations that to be cancelled
            var operationsToBeCancel = allPendingOperation
            let visibleCells = Set(visibleIndexPathArray)
            operationsToBeCancel.subtract(visibleCells)
            // Determining operation that to be started
            var operationsToBeStarted = visibleCells
            operationsToBeStarted.subtract(allPendingOperation)
            // Cancelling all the operations
            operationsToBeCancel.forEach { indexPath in
                operations.downloadOperation(at: indexPath)?.cancel()
                operations.removeDownloadOperation(at: indexPath)
                operations.filterOperation(at: indexPath)?.cancel()
                operations.removeFilterOperation(at: indexPath)
            }
            // resuming operations
            operationsToBeStarted.forEach { indexPath in
                let photo = self.photo(at: indexPath.row)
                checkOperation(for: photo, at: indexPath, in: tableView)
            }
        }
    }
    private func checkOperation(for photo: PhotoProtocol, at index: IndexPath, in tableView: UITableView) {
        switch photo.state {
        case .new, .downloaded:
            // start activity
            // download/filter operation for image
            self.startOperations(for: photo, at: index, in: tableView)
            
        case .failed:
            // hide the activity indicator
            break
            
        case .filtered:
            // hide the activity indicator
            break
        }
    }
    private func startOperations(for photo: PhotoProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        switch photo.state {
        case .new:
            self.startDownload(for: photo, at: indexPath, in: tableView)
            
        case .downloaded:
            self.startFiltration(for: photo, at: indexPath, in: tableView)
            
        default:
            break
        }
    }
    private func startDownload(for photo: PhotoProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        guard operations.downloadOperation(at: indexPath) == nil else {
            return
        }
        let photoDownloaderOp = PhotoDownloaderOperation(photo: photo)
        photoDownloaderOp.completionBlock = {
            if photoDownloaderOp.isCancelled {
                return
            }
            OperationQueue.main.addOperation {
                self.operations.removeDownloadOperation(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        operations.addDownload(operation: photoDownloaderOp, at: indexPath)
    }
    private func startFiltration(for photo: PhotoProtocol, at indexPath: IndexPath, in tableView: UITableView) {
        guard operations.filterOperation(at: indexPath) == nil else {
            return
        }
        let photoFiltrationOp = PhotoFilterOperation(photo: photo)
        photoFiltrationOp.completionBlock = {
            if photoFiltrationOp.isCancelled {
                return
            }
            OperationQueue.main.addOperation {
                self.operations.removeFilterOperation(at: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        operations.addFilter(operation: photoFiltrationOp, at: indexPath)
    }
}

class PendingOperations {
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    lazy var filterInProgress: [IndexPath: Operation] = [:]
    private lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    private lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Filter Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func addDownload(operation: Operation, at indexPath: IndexPath) {
        downloadInProgress[indexPath] = operation
        downloadQueue.addOperation(operation)
    }
    func addFilter(operation: Operation, at indexPath: IndexPath) {
        filterInProgress[indexPath] = operation
        filtrationQueue.addOperation(operation)
    }
    func removeDownloadOperation(at indexPath: IndexPath) {
        downloadInProgress.removeValue(forKey: indexPath)
    }
    func removeFilterOperation(at indexPath: IndexPath) {
        filterInProgress.removeValue(forKey: indexPath)
    }
    func downloadOperation(at indexPath: IndexPath) -> Operation? {
        downloadInProgress[indexPath]
    }
    func filterOperation(at indexPath: IndexPath) -> Operation? {
        filterInProgress[indexPath]
    }
    func suspendResumeAllOperations(isSuspended: Bool) {
        downloadQueue.isSuspended = isSuspended
        filtrationQueue.isSuspended = isSuspended
    }
}
//
//    private let router = Router<PhotoAPI>()
//    private let apiKey = ""
//    weak var delegate: PhotoViewModelDelegate?
//
//    var photoData: [PhotoCellViewModelProtocol] {
//        didSet {
//            self.delegate?.reloadData()
//        }
//    }
//    init(delegate: PhotoViewModelDelegate) {
//        self.delegate = delegate
//        self.photoData = []
//    }
//
//    func getPhotoImage() {
//        router.request(.defaultSearch(apiKey: self.apiKey)) { [weak self] (results: Result<Photos, AppError>) in
//            guard let self = self else { return }
//            switch results {
//            case .success(let data):
//
//                self.photoData = data.compactMap {
//                    PhotoCellViewModel(photo: $0)
//                }
//
//            case .failure(let error):
//                // insert your modifications!
//                print(error)
//            }
//        }
//    }
//    func numberOfRowsIn(section: Int) -> Int {
//        self.photoData.count
//    }
//
//    func photo(at index: Int) -> PhotoCellViewModelProtocol {
//        self.photoData[index]
//    }
// }
