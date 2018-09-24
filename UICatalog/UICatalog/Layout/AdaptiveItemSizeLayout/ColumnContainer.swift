//
//  ColumnContainer.swift
//  AdaptiveItemSizeLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ColumnContainer {
    private var columns = [Column]()
    private let configuration: AdaptiveItemSizeLayout.Configuration
    
    init(configuration: AdaptiveItemSizeLayout.Configuration) {
        self.configuration = configuration
        columns = [Column]()
        (0..<configuration.columnCount).forEach{
            let column = Column(configuration: configuration, columnNumber: $0)
            self.columns.append(column)
        }
    }
    
    var bottom: CGFloat {
        let bottomItem = columns.sorted { (column1, column2) -> Bool in
            column1.maxY < column2.maxY
        }.last
        
        if let maxY = bottomItem?.maxY {
            return maxY + configuration.sectionInsets.bottom
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    var all: [Column] {
        return columns
    }
    
    var next: Column? {
        return columns.sorted { (column1, column2) -> Bool in
            column1.maxY < column2.maxY
        }.first
    }
    
    func reset() {
        let count = columns.count
        columns = [Column]()
        (0..<count).forEach{
            let column = Column(configuration: configuration, columnNumber: $0)
            self.columns.append(column)
        }
    }
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        next?.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
}
