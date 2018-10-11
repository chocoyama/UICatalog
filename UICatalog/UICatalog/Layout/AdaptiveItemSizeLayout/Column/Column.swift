//
//  Column.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class Column: Line {
    let configuration: AdaptiveHeightConfiguration
    let section: Int
    let number: Int // zero origin
    let collectionViewWidth: CGFloat
    
    var originX: CGFloat {
        var x = configuration.sectionInsets.left
        if number != 0 {
            x += (width + configuration.minimumInterItemSpacing) * CGFloat(number)
        }
        return x
    }
    var originY: CGFloat = 0.0
    var maxX: CGFloat { return originX + width }
    private(set) var maxY: CGFloat = 0.0
    var width: CGFloat {
        let totalHorizontalInsets = configuration.sectionInsets.left + configuration.sectionInsets.right
        let totalInterItemSpace = configuration.minimumInterItemSpacing * CGFloat(configuration.totalSpace)
        let itemWidth = (collectionViewWidth - totalHorizontalInsets - totalInterItemSpace) / CGFloat(configuration.columnCount)
        return itemWidth
    }
    var height: CGFloat { return maxY }
    
    var attributesSet = [UICollectionViewLayoutAttributes]()
    
    init(
        configuration: AdaptiveHeightConfiguration,
        section: Int,
        columnNumber: Int,
        collectionViewWidth: CGFloat
    ) {
        self.section = section
        self.configuration = configuration
        self.number = columnNumber
        self.collectionViewWidth = collectionViewWidth
    }
}

extension Column {
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(
            x: originX,
            y: nextOriginY,
            width: width,
            height: itemSize.height * width / itemSize.width
        )
        maxY = attributes.frame.maxY
        attributesSet.append(attributes)
    }
    
    func update(addingBottom: CGFloat) {
        attributesSet.forEach {
            $0.frame = CGRect(
                x: $0.frame.origin.x,
                y: $0.frame.origin.y + addingBottom,
                width: $0.frame.width,
                height: $0.frame.height
            )
        }
        self.originY = originY + addingBottom
        self.maxY = maxY + addingBottom
    }
    
    private var nextOriginY: CGFloat {
        if attributesSet.isEmpty {
            return configuration.sectionInsets.top
        } else {
            return maxY + configuration.minimumLineSpacing
        }
    }
}
