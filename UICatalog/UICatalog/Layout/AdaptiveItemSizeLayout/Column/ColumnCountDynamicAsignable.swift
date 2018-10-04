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
    private func reloadLayout(configuration: AdaptiveHeightConfiguration) {
        let newLayout = AdaptiveItemSizeLayout(adaptType: .height(configuration))
        newLayout.delegate = self
        collectionView.setCollectionViewLayout(newLayout, animated: true) { [weak self] (result) in
            self?.collectionView.reloadData()
        }
    }
    
    @discardableResult
    public func incrementColumn() -> Bool {
        guard let layout = getAdaptiveItemSizeLayout(),
            var configuration = (layout.container as? ColumnContainer)?.configuration,
            !configuration.atMaxColumn else { return false }
        configuration.columnCount += 1
        reloadLayout(configuration: configuration)
        return true
    }
    
    @discardableResult
    public func decrementColumn() -> Bool {
        guard let layout = getAdaptiveItemSizeLayout(),
            var configuration = (layout.container as? ColumnContainer)?.configuration,
            !configuration.atMinColumn else { return false }
        configuration.columnCount -= 1
        reloadLayout(configuration: configuration)
        return true
    }
}
