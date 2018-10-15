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
            return maxY
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
        self.headers = []
        for section in (0..<collectionView.numberOfSections) {
            (0..<self.configuration.columnCount).forEach {
                self.lines.append(Column(
                    configuration: self.configuration,
                    section: section,
                    columnNumber: $0,
                    collectionViewWidth: collectionView.bounds.width
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
        var maxYDicBySection = [Int: CGFloat]()
        
        lines.forEach { (line) in
            if let bottom = maxYDicBySection[line.section] {
                if bottom < line.maxY {
                    maxYDicBySection[line.section] = line.maxY
                }
            } else {
                maxYDicBySection[line.section] = line.maxY
            }
        }

        lines.forEach { (line) in
            let previousSectionBottom = maxYDicBySection[line.section - 1] ?? 0.0
            let headerHeight = headers
                .first(where: { $0.section == line.section })?
                .attributes.frame.height ?? 0.0
            let lineSpacing: CGFloat
            if line.section == 0 {
                lineSpacing = configuration.minimumLineSpacing
            } else {
                lineSpacing = configuration.minimumLineSpacing * 2 - configuration.sectionInsets.top
            }
            let addingBottom = previousSectionBottom + headerHeight + lineSpacing
            line.update(addingBottom: addingBottom)
            
            if let maxY = maxYDicBySection[line.section], maxY < line.maxY {
                maxYDicBySection[line.section] = line.maxY
            }
        }

        headers.forEach { (header) in
            if let maxY = maxYDicBySection[header.section - 1] {
                header.update(originY: maxY + configuration.minimumLineSpacing)
            } else {
                // 一番最初のセクションヘッダーの時
                header.update(originY: configuration.sectionInsets.top)
            }
        }
    }
}
