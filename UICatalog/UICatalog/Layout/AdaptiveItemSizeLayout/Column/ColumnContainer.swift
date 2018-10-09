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
        var newLines = [Column]()
        lines.forEach { (line) in
            newLines.append(Column(
                configuration: configuration,
                section: line.section,
                columnNumber: line.number
            ))
        }
        self.lines = newLines
    }
}

extension ColumnContainer: Containerable {
    func configure(by collectionView: UICollectionView) {
        self.lines = []
        for section in (0..<collectionView.numberOfSections) {
            (0..<self.configuration.columnCount).forEach {
                self.lines.append(Column(
                    configuration: self.configuration,
                    section: section,
                    columnNumber: $0
                ))
            }
        }
    }
    
    func addItem(indexPath: IndexPath, itemSize: CGSize) {
        nextLine?.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        return CGSize(width: collectionViewWidth, height: bottomY)
    }
    
    func reset(by collectionView: UICollectionView) {
        configure(by: collectionView)
    }
}
