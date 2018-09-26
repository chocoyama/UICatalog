//
//  ColumnContainer.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ColumnContainer {
    typealias Configuration = AdaptiveItemHeightLayout.Configuration
    
    private var columns = [AdaptiveItemHeightLayout.Column]()
    let configuration: AdaptiveItemHeightLayout.Configuration
    
    init(configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
        columns = [AdaptiveItemHeightLayout.Column]()
        (0..<self.configuration.columnCount).forEach{
            let column = AdaptiveItemHeightLayout.Column(configuration: self.configuration, columnNumber: $0)
            self.columns.append(column)
        }
    }
    
    private var next: AdaptiveItemHeightLayout.Column? {
        return columns.sorted { (column1, column2) -> Bool in
            column1.maxY < column2.maxY
        }.first
    }
    
    private var bottomY: CGFloat {
        let bottomItem = columns.sorted { (column1, column2) -> Bool in
            column1.maxY < column2.maxY
            }.last
        
        if let maxY = bottomItem?.maxY {
            return maxY + configuration.sectionInsets.bottom
        } else {
            return .leastNormalMagnitude
        }
    }
}

extension ColumnContainer: Containerable {
    func setCollectionViewFrame(_ frame: CGRect) {}
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        next?.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        return CGSize(width: collectionViewWidth, height: bottomY)
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return columns.flatMap { $0.getAttributes(rect: rect) }
    }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return columns.compactMap { $0.getAttributes(indexPath: indexPath) }.first
    }
    
    func reset() {
        let count = columns.count
        columns = [AdaptiveItemHeightLayout.Column]()
        (0..<count).forEach {
            let column = AdaptiveItemHeightLayout.Column(configuration: configuration, columnNumber: $0)
            self.columns.append(column)
        }
    }
}
