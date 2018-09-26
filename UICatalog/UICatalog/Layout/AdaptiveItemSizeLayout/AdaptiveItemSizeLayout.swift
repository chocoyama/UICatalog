//
//  AdaptiveItemSizeLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemSizeLayout: UICollectionViewLayout {
    public let container: Containerable
    
    public init(container: Containerable) {
        self.container = container
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return container.layoutAttributesForElements(in: rect)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return container.layoutAttributesForItem(at: indexPath)
    }
    
    open override var collectionViewContentSize: CGSize {
        let collectionViewWidth = collectionView?.bounds.width ?? .leastNormalMagnitude
        return container.collectionViewContentSize(by: collectionViewWidth)
    }
    
    open func reset() {
        container.reset()
    }
}
