//
//  Column.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class Column: Item {
    let number: Int // zero origin
    
    var maxX: CGFloat {
        return originX + configuration.itemWidth
    }
    
    private(set) var maxY: CGFloat = 0.0
    var originX: CGFloat {
        var x = configuration.sectionInsets.left
        if number != 0 {
            x += (configuration.itemWidth + configuration.minimumInterItemSpacing) * CGFloat(number)
        }
        return x
    }
    let originY: CGFloat = 0.0
    var width: CGFloat { return configuration.itemWidth }
    var height: CGFloat { return maxY }
    
    private var nextOriginY: CGFloat {
        if attributesSet.isEmpty {
            return configuration.sectionInsets.top
        } else {
            return maxY + configuration.minimumLineSpacing
        }
    }
    
    private let configuration: AdaptiveHeightConfiguration
    var attributesSet = [UICollectionViewLayoutAttributes]()
    
    init(configuration: AdaptiveHeightConfiguration, columnNumber: Int) {
        self.configuration = configuration
        self.number = columnNumber
    }
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(
            x: originX,
            y: nextOriginY,
            width: configuration.itemWidth,
            height: configuration.itemHeight(rawItemSize: itemSize)
        )
        maxY = attributes.frame.maxY
        attributesSet.append(attributes)
    }
}
