//
//  ColumnContainer.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ColumnContainer {
    typealias Configuration = AdaptiveHeightConfiguration
    
    var items: [Item] = []
    let configuration: AdaptiveHeightConfiguration
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
        items = [Column]()
        (0..<self.configuration.columnCount).forEach{
            let column = Column(configuration: self.configuration, columnNumber: $0)
            self.items.append(column)
        }
    }
    
    private var next: Item? {
        return items.sorted { (column1, column2) -> Bool in
            column1.maxY < column2.maxY
        }.first
    }
    
    private var bottomY: CGFloat {
        let bottomItem = items.sorted { (column1, column2) -> Bool in
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
    
    func reset() {
        let count = items.count
        items = [Column]()
        (0..<count).forEach {
            let column = Column(configuration: configuration, columnNumber: $0)
            self.items.append(column)
        }
    }
}
