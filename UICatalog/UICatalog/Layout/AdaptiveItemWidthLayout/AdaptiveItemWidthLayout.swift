//
//  AdaptiveItemWidthLayout.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemWidthLayout: UICollectionViewLayout {
    open weak var delegate: AdaptiveItemWidthLayoutable?
    
    open var configuration = Configuration()
    private var rowContainer: RowContainer
    
    public init(configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        self.rowContainer = RowContainer(configuration: self.configuration)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.rowContainer = RowContainer(configuration: self.configuration)
        super.init(coder: aDecoder)
    }
    
}

extension AdaptiveItemWidthLayout {
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        reset()
        rowContainer.setCollectionViewWidth(collectionView.frame.width)
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.sizeForItem(at: indexPath) ?? .zero
                rowContainer.addAttributes(indexPath: indexPath, itemSize: itemSize)
            }
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return rowContainer.layoutAttributesForElements(in: rect)
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return rowContainer.layoutAttributesForItem(at: indexPath)
    }
    
    override open var collectionViewContentSize: CGSize {
        return rowContainer.collectionViewContentSize
    }
    
    private func reset() {
        rowContainer.reset()
    }
    
}
