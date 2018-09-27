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
    
    var lines: [Line] = []
    let configuration: AdaptiveHeightConfiguration
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
        lines = [Column]()
        (0..<self.configuration.columnCount).forEach{
            let column = Column(configuration: self.configuration, columnNumber: $0)
            self.lines.append(column)
        }
    }
    
    private var nextLine: Line? {
        return lines.sorted { (line1, line2) -> Bool in
            line1.maxY < line2.maxY
        }.first
    }
    
    private var bottomY: CGFloat {
        let bottomLine = lines.sorted { (line1, line2) -> Bool in
            line1.maxY < line2.maxY
        }.last
        
        if let maxY = bottomLine?.maxY {
            return maxY + configuration.sectionInsets.bottom
        } else {
            return .leastNormalMagnitude
        }
    }
    
    /// あらかじめ必要な分のカラムを生成しておく
    private func setUpColumns() {
        let count = lines.count
        lines = [Column]()
        (0..<count).forEach {
            self.lines.append(Column(configuration: configuration, columnNumber: $0))
        }
    }
}

extension ColumnContainer: Containerable {
    func setCollectionViewFrame(_ frame: CGRect) {}
    
    func addItem(indexPath: IndexPath, itemSize: CGSize) {
        nextLine?.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        return CGSize(width: collectionViewWidth, height: bottomY)
    }
    
    func reset() {
        setUpColumns()
    }
}
