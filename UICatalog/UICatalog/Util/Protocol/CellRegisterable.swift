//
//  CellRegisterable.swift
//  MiseryPot
//
//  Created by takyokoy on 2017/12/27.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

public protocol CellRegisterable {}
extension CellRegisterable {
    static public var cellIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: CellRegisterable {}
extension CellRegisterable where Self: UITableViewCell {
    static public func register(for tableView: UITableView, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cellIdentifier, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    static public func dequeue(from tableView: UITableView, indexPath: IndexPath) -> Self {
        let name = String(describing: Self.self)
        return tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as! Self
    }
}

extension UICollectionViewCell: CellRegisterable {}
extension CellRegisterable where Self: UICollectionViewCell {
    static public func register(for collectionView: UICollectionView, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cellIdentifier, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    static public func dequeue(from collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        let name = String(describing: Self.self)
        return collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as! Self
    }
}
