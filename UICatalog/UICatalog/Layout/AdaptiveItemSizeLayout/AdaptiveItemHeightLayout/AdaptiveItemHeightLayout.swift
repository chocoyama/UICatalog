//
//  AdaptiveItemHeightLayout.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/30.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemHeightLayout: AdaptiveItemSizeLayout {
    open weak var delegate: AdaptiveItemHeightLayoutable?
    
    open var configuration = AdaptiveItemHeightLayout.Configuration()
    
    public init(configuration: AdaptiveItemHeightLayout.Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        super.init(container: ColumnContainer(configuration: self.configuration))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        reset()
        container.setCollectionViewFrame(collectionView.frame)

        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.sizeForItem(at: indexPath) ?? .zero
                container.addAttributes(indexPath: indexPath, itemSize: itemSize)
            }
        }
    }
}
