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
    
    private(set) var headers: [Header] = []
    var lines: [Line] = []
    let configuration: AdaptiveHeightConfiguration
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
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
    
    private func getNextLine(section: Int) -> Line? {
        return lines
            .filter { $0.section == section }
            .sorted { (line1, line2) -> Bool in
                line1.maxY < line2.maxY
            }.first
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
        let nextLine = getNextLine(section: indexPath.section)
        nextLine?.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func addHeader(section: Int, size: CGSize) {
        headers.append(Header(section: section, size: size))
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        return CGSize(width: collectionViewWidth, height: bottomY)
    }
    
    func reset(by collectionView: UICollectionView) {
        configure(by: collectionView)
    }
    
    func finish() {
//        ヘッダーのframeでずらしていsく
        
        var bottomMap = [Int: CGFloat]()
        lines.forEach { (line) in
            if let bottom = bottomMap[line.section] {
                if bottom < line.maxY {
                    bottomMap[line.section] = line.maxY
                }
            } else {
                bottomMap[line.section] = line.maxY
            }
        }
        
        lines.forEach { (line) in
            guard let bottom = bottomMap[line.section - 1] else { return }
            let addingBottom = bottom + configuration.minimumLineSpacing
            line.update(addingBottom: line.maxY + addingBottom)
        }
    }
}
