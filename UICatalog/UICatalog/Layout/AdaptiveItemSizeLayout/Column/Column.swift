//
//  Column.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class Column: Line {
    let section: Int
    let number: Int // zero origin
    
    var maxX: CGFloat { return originX + width }
    private(set) var maxY: CGFloat = 0.0
    var originX: CGFloat {
        var x = configuration.sectionInsets.left
        if number != 0 {
            x += (width + configuration.minimumInterItemSpacing) * CGFloat(number)
        }
        return x
    }
    let originY: CGFloat = 0.0
    var width: CGFloat {
        let totalHorizontalInsets = configuration.sectionInsets.left + configuration.sectionInsets.right
        let totalInterItemSpace = configuration.minimumInterItemSpacing * CGFloat(configuration.totalSpace)
        let itemWidth = (UIScreen.main.bounds.width - totalHorizontalInsets - totalInterItemSpace) / CGFloat(configuration.columnCount)
        return itemWidth
    }
    var height: CGFloat { return maxY }
    
    private let configuration: AdaptiveHeightConfiguration
    var attributesSet = [UICollectionViewLayoutAttributes]()
    
    init(
        configuration: AdaptiveHeightConfiguration,
        section: Int,
        columnNumber: Int
    ) {
        self.section = section
        self.configuration = configuration
        self.number = columnNumber
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
    
    func update(maxY: CGFloat) {
        self.maxY = maxY
    }
    
    private var nextOriginY: CGFloat {
        if attributesSet.isEmpty {
            return configuration.sectionInsets.top
        } else {
            return maxY + configuration.minimumLineSpacing
        }
    }
}
