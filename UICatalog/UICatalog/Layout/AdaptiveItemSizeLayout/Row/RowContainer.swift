//
//  RowContainer.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class RowContainer {
    typealias Configuration = AdaptiveWidthConfiguration
    
    private(set) var headers: [Header] = []
    var lines: [SectionLine] = []
    let configuration: AdaptiveWidthConfiguration
    
    private var collectionViewWidth: CGFloat = .leastNormalMagnitude
    private var limitX: CGFloat = .leastNormalMagnitude
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
    }
    
    private var nextRowOriginY: CGFloat {
        if let lastLine = lines.last {
            return lastLine.maxY + configuration.minimumLineSpacing
        } else {
            return configuration.sectionInsets.top
        }
    }
    
    private func getCapableLine(section: Int, nextItemSize: CGSize) -> Line? {
        return lines.filter {
            let equalSection = $0.section == section
            let equalHeight = $0.height == nextItemSize.height
            let overLimit = $0.maxX + nextItemSize.width > limitX
            return equalSection && equalHeight && !overLimit
        }.first
    }
    
    /// 追加したいCellの高さに適合したItemがない場合、新たにItemを生成する
    ///
    /// - Parameter height: 生成するItemの高さ
    /// - Returns: 生成したItem
    private func addNewLine(section: Int, height: CGFloat) -> Line {
        let newLine = Row(
            configuration: configuration,
            section: section,
            rowNumber: lines.count,
            height: height,
            originY: nextRowOriginY,
            width: self.collectionViewWidth
        )
        lines.append(newLine)
        return newLine
    }
}

extension RowContainer: Containerable {
    func configure(by collectionView: UICollectionView) {
        self.collectionViewWidth = collectionView.frame.width
        self.limitX = collectionView.frame.width - configuration.sectionInsets.right
    }
    
    func addItem(indexPath: IndexPath, itemSize: CGSize) {
        let line: Line
        if let capableLine = getCapableLine(section: indexPath.section, nextItemSize: itemSize) {
            line = capableLine
        } else {
            line = addNewLine(section: indexPath.section, height: itemSize.height)
        }
        
        try? line.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func addHeader(section: Int, size: CGSize) {
        headers.append(Header(section: section, size: size))
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        let height = lines.sorted { (line1, line2) -> Bool in
            line1.number > line2.number
        }
        .first
        .map { $0.maxY + configuration.sectionInsets.bottom }
        
        return CGSize(width: collectionViewWidth, height: height ?? 0.0)
    }
    
    func reset(by collectionView: UICollectionView) {
        lines = []
        headers = []
    }
    
    func finish() {
        lines.forEach { (line) in
            let totalHeaderHeight = headers
                .filter { $0.section <= line.section }
                .reduce(0, { (total, header) -> CGFloat in
                    return total + header.attributes.frame.height
                })
            let totalMarginHeight = configuration.minimumLineSpacing * CGFloat(line.section + 1)
            line.moveDownward(by: totalHeaderHeight + totalMarginHeight)
        }
        
        headers.forEach { (header) in
            let previousSectionMaxY = lines
                .filter { $0.section == header.section - 1 }
                .sorted(by: { (line1, line2) -> Bool in
                    line1.maxY > line2.maxY
                })
                .first
                .map { $0.maxY }
            
            if let previousSectionMaxY = previousSectionMaxY {
                header.update(originY: previousSectionMaxY + configuration.minimumLineSpacing)
            } else {
                // 一番最初のセクションヘッダーの時
                header.update(originY: configuration.sectionInsets.top)
            }
        }
    }
}
