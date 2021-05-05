//
//  OperationQueueViewController.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

class PhotoViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView.viewWithOutARMask()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerNibCell(PhotoTableViewCell.self)
        return tableView
    }()
    lazy var viewModel = PhotoViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSafeConstrainedSubView(tableView)
        viewModel.fetchPhotoDetails()
    }
}

extension PhotoViewController: PhotoListViewModelDelegate {
    func reload() {
        self.tableView.reloadData()
    }
    func show(error: AppError) {
    }
}

extension PhotoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(in: tableView, for: indexPath)
    }
}

extension PhotoViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendResumeAllOperations(isSuspended: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.performOperationForOnScreenCells(in: self.tableView)
        viewModel.suspendResumeAllOperations(isSuspended: false)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            viewModel.performOperationForOnScreenCells(in: self.tableView)
            viewModel.suspendResumeAllOperations(isSuspended: false)
        }
    }
}
