//
//  AdaptiveItemWidthLayout.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemWidthLayout: AdaptiveItemSizeLayout {
    open weak var delegate: AdaptiveItemWidthLayoutable?
    
    open var configuration = AdaptiveItemWidthLayout.Configuration()
    
    public init(configuration: AdaptiveItemWidthLayout.Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        super.init(container: RowContainer(configuration: self.configuration))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
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
