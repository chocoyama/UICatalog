//
//  AdaptiveItemSizeLayoutable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/24.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol AdaptiveItemSizeLayoutable: class {
    var layout: AdaptiveItemSizeLayout { get set }
    var collectionView: UICollectionView! { get }
    func sizeForItem(at indexPath: IndexPath) -> CGSize
}

extension AdaptiveItemSizeLayoutable where Self: UIViewController {
    public func reloadLayout() {
        let layout = AdaptiveItemSizeLayout(configuration: self.layout.configuration)
        layout.delegate = self
        
        collectionView.setCollectionViewLayout(layout, animated: true) { [weak self] (result) in
            self?.collectionView.reloadData()
            self?.layout = layout
        }
    }
    
    @discardableResult
    public func incrementColumn() -> Bool {
        guard !layout.configuration.atMaxColumn else { return false }
        layout.configuration.columnCount += 1
        reloadLayout()
        return true
    }
    
    @discardableResult
    public func decrementColumn() -> Bool {
        guard !layout.configuration.atMinColumn else { return false }
        layout.configuration.columnCount -= 1
        reloadLayout()
        return true
    }
}
