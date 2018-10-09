//
//  Row.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

class Row: Line {
    let section: Int
    let number: Int // zero origin
    
    private(set) var maxX: CGFloat = 0.0
    var maxY: CGFloat {
        return originY + height
    }
    let originX: CGFloat = 0.0
    let originY: CGFloat
    let width: CGFloat
    let height: CGFloat
    
    private let configuration: AdaptiveWidthConfiguration
    var attributesSet = [UICollectionViewLayoutAttributes]()
    
    init(
        configuration: AdaptiveWidthConfiguration,
        section: Int,
        rowNumber: Int,
        height: CGFloat,
        originY: CGFloat,
        width: CGFloat
    ) {
        self.configuration = configuration
        self.section = section
        self.number = rowNumber
        self.height = height
        self.originY = originY
        self.width = width
    }
}

extension Row {
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
    
    private var nextOriginX: CGFloat {
        if attributesSet.isEmpty {
            return configuration.sectionInsets.left
        } else {
            return maxX + configuration.minimumInterItemSpacing
        }
    }
}
