//
//  AdaptiveItemHeightLayoutable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/24.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol AdaptiveItemHeightLayoutable: class {
    var collectionView: UICollectionView! { get }
    func sizeForItem(at indexPath: IndexPath) -> CGSize
}

extension AdaptiveItemHeightLayoutable where Self: UIViewController {
    public var layout: AdaptiveItemHeightLayout? {
        return collectionView.collectionViewLayout as? AdaptiveItemHeightLayout
    }
    
    public func reloadLayout() {
        guard let layout = self.layout else { return }
        
        let newLayout = AdaptiveItemHeightLayout(configuration: layout.configuration)
        newLayout.delegate = self
        collectionView.setCollectionViewLayout(newLayout, animated: true) { [weak self] (result) in
            self?.collectionView.reloadData()
        }
    }
    
    @discardableResult
    public func incrementColumn() -> Bool {
        guard self.layout?.configuration.atMaxColumn == false else { return false }
        layout?.configuration.columnCount += 1
        reloadLayout()
        return true
    }
    
    @discardableResult
    public func decrementColumn() -> Bool {
        guard self.layout?.configuration.atMinColumn == false else { return false }
        layout?.configuration.columnCount -= 1
        reloadLayout()
        return true
    }
}
