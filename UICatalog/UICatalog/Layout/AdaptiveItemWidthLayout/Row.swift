//
//  Row.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

extension AdaptiveItemWidthLayout {
    class Row {
        let rowNumber: Int // zero origin
        var maxY: CGFloat { return originY + configuration.rowHeight }
        private(set) var maxX: CGFloat = 0.0
        
        private let configuration: AdaptiveItemWidthLayout.Configuration
        private var attributesSet = [UICollectionViewLayoutAttributes]()
        
        init(configuration: AdaptiveItemWidthLayout.Configuration, rowNumber: Int) {
            self.configuration = configuration
            self.rowNumber = rowNumber
        }
        
        func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(
                x: originX,
                y: originY,
                width: itemSize.width,
                height: itemSize.height
            )
            maxX = attributes.frame.maxX
            attributesSet.append(attributes)
        }
        
        func getAttributes(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return attributesSet.filter {
                let equalSection = $0.indexPath.section == indexPath.section
                let equalItem = $0.indexPath.item == indexPath.item
                return equalSection && equalItem
            }.first
        }
        
        func getAttributes(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
            return attributesSet.filter { $0.frame.intersects(rect) }
        }
        
        private var originX: CGFloat {
            if attributesSet.isEmpty {
                return configuration.sectionInsets.left
            } else {
                return maxX + configuration.minimumInterItemSpacing
            }
        }
        
        private var originY: CGFloat {
            if rowNumber == 0 {
                return configuration.sectionInsets.top
            } else {
                let topMargin = configuration.sectionInsets.top
                let totalCellHeight = configuration.rowHeight * CGFloat(rowNumber)
                let totalLineSpacing = configuration.minimumLineSpacing * CGFloat(rowNumber)
                return topMargin + totalCellHeight + totalLineSpacing
            }
        }
    }
}
