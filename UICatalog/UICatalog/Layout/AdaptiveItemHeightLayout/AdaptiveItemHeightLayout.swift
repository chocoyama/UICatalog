//
//  AdaptiveItemHeightLayout.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/30.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemHeightLayout: UICollectionViewLayout {
    
    open weak var delegate: AdaptiveItemHeightLayoutable?
    
    open var configuration = Configuration()
    private var columnContainer: ColumnContainer
    
    public init(configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        self.columnContainer = ColumnContainer(configuration: self.configuration)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.columnContainer = ColumnContainer(configuration: self.configuration)
        super.init(coder: aDecoder)
    }
    
}

extension AdaptiveItemHeightLayout {
    override open func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        reset()
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.sizeForItem(at: indexPath) ?? .zero
                columnContainer.addAttributes(indexPath: indexPath, itemSize: itemSize)
            }
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return columnContainer.layoutAttributesForElements(in: rect)
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return columnContainer.layoutAttributesForItem(at: indexPath)
    }
    
    override open var collectionViewContentSize: CGSize {
        let collectionViewWidth = collectionView?.bounds.width ?? .leastNormalMagnitude
        return columnContainer.collectionViewContentSize(by: collectionViewWidth)
    }
    
    private func reset() {
        columnContainer.reset()
    }
}
