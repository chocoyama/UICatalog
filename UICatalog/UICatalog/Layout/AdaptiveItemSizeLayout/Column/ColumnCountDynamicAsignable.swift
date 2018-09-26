//
//  AdaptiveItemHeightLayoutable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/24.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol ColumnCountDynamicAsignable {}

extension ColumnCountDynamicAsignable where Self: AdaptiveItemSizeLayoutDelegate {
    public var layout: AdaptiveItemSizeLayout? {
        return collectionView.collectionViewLayout as? AdaptiveItemSizeLayout
    }
    
    public var configuration: AdaptiveHeightConfiguration? {
        return (layout?.container as? ColumnContainer)?.configuration
    }
    
    private func reloadLayout(configuration: AdaptiveHeightConfiguration) {
        let newLayout = AdaptiveItemSizeLayout(adaptType: .height(configuration))
        newLayout.delegate = self
        collectionView.setCollectionViewLayout(newLayout, animated: true) { [weak self] (result) in
            self?.collectionView.reloadData()
        }
    }
    
    @discardableResult
    public func incrementColumn() -> Bool {
        guard var configuration = self.configuration,
            !configuration.atMaxColumn else { return false }
        configuration.columnCount += 1
        reloadLayout(configuration: configuration)
        return true
    }
    
    @discardableResult
    public func decrementColumn() -> Bool {
        guard var configuration = self.configuration,
            !configuration.atMinColumn else { return false }
        configuration.columnCount -= 1
        reloadLayout(configuration: configuration)
        return true
    }
}
