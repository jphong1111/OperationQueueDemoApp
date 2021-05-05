//
//  OperationQueueTableViewCell.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/4/21.
//

import UIKit

class PhotoTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    var photo: PhotoProtocol? = nil {
        didSet {
            self.photoImageView.image = photo?.image
            self.title.text = photo?.title
            guard let state = photo?.state else { return }
            switch state {
            case .new, .downloaded:
                self.indicatorView.startAnimating()
                
            case .failed, .filtered:
                self.indicatorView.stopAnimating()
            }
        }
    }
}
