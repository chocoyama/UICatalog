//
//  AdaptiveItemSizeLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemSizeLayout: UICollectionViewLayout {
    public enum AdaptType {
        case height(AdaptiveHeightConfiguration)
        case width(AdaptiveWidthConfiguration)
    }
    
    public let container: Containerable
    open weak var delegate: AdaptiveItemSizeLayoutDelegate?
    
    public init(adaptType: AdaptType) {
        switch adaptType {
        case .height(let configuration): self.container = ColumnContainer(configureBy: configuration)
        case .width(let configuration): self.container = RowContainer(configureBy: configuration)
        }
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        reset(by: collectionView)
        container.configure(by: collectionView)
        
        for section in (0..<collectionView.numberOfSections) {
            if let headerSize = delegate?.adaptiveItemSizeLayout(self, referenceSizeForHeaderIn: section),
                headerSize != .zero {
                container.addHeader(section: section, size: headerSize)
            }
            
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.adaptiveItemSizeLayout(self, sizeForItemAt: indexPath) ?? .zero
                container.addItem(indexPath: indexPath, itemSize: itemSize)
            }
        }
        
        container.finish()
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return container.layoutAttributesForElements(in: rect)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return container.layoutAttributesForItem(at: indexPath)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return container.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    open override var collectionViewContentSize: CGSize {
        let collectionViewWidth = collectionView?.bounds.width ?? .leastNormalMagnitude
        return container.collectionViewContentSize(by: collectionViewWidth)
    }
    
    open func reset(by collectionView: UICollectionView) {
        container.reset(by: collectionView)
    }
}
