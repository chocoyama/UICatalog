//
//  Row.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

class Row: Item {
    let rowNumber: Int // zero origin
    
    private(set) var maxX: CGFloat = 0.0
    var maxY: CGFloat {
        return originY + height
    }
    let originX: CGFloat = 0.0
    let originY: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    private var nextOriginX: CGFloat {
        if attributesSet.isEmpty {
            return configuration.sectionInsets.left
        } else {
            return maxX + configuration.minimumInterItemSpacing
        }
    }
    
    private let configuration: AdaptiveWidthConfiguration
    var attributesSet = [UICollectionViewLayoutAttributes]()
    
    init(
        configuration: AdaptiveWidthConfiguration,
        rowNumber: Int,
        height: CGFloat,
        originY: CGFloat,
        width: CGFloat
    ) {
        self.configuration = configuration
        self.rowNumber = rowNumber
        self.height = height
        self.originY = originY
        self.width = width
    }
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(
            x: nextOriginX,
            y: originY,
            width: itemSize.width,
            height: itemSize.height
        )
        maxX = attributes.frame.maxX
        attributesSet.append(attributes)
    }
}
