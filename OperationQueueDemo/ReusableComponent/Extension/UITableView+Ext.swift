//
//  UITableView+Ext.swift
//  OperationQueueDemo
//
//  Created by JungpyoHong on 5/5/21.
//

import UIKit

protocol ReusableView {
    static var identifier: String { get }
}

extension ReusableView where Self: UIView {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier")
        }
        return cell
    }
    
    func registerCell<T: UITableViewCell>(_ cellClasses: T.Type...) where T: ReusableView {
        cellClasses.forEach { self.register($0, forCellReuseIdentifier: $0.identifier) }
    }
    
    func registerNibCell<T: UITableViewCell>(_ cellClasses: T.Type...) where T: ReusableView {
        cellClasses.forEach { self.register(UINib(nibName: $0.identifier, bundle: Bundle.main), forCellReuseIdentifier: $0.identifier) }
    }
}
