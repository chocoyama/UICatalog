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
    
    var lines: [Line] = []
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
    
    private func getCapableLine(nextItemSize: CGSize) -> Line? {
        return lines.filter {
            let equalHeight = $0.height == nextItemSize.height
            let overLimit = $0.maxX + nextItemSize.width > limitX
            return equalHeight && !overLimit
        }.first
    }
    
    /// 追加したいCellの高さに適合したItemがない場合、新たにItemを生成する
    ///
    /// - Parameter height: 生成するItemの高さ
    /// - Returns: 生成したItem
    private func addNewLine(with height: CGFloat) -> Line {
        let newLine = Row(
            configuration: configuration,
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
    func setCollectionViewFrame(_ frame: CGRect) {
        self.collectionViewWidth = frame.width
        self.limitX = frame.width - configuration.sectionInsets.right
    }
    
    func addItem(indexPath: IndexPath, itemSize: CGSize) {
        let line: Line
        if let capableLine = getCapableLine(nextItemSize: itemSize) {
            line = capableLine
        } else {
            line = addNewLine(with: itemSize.height)
        }
        line.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        let height = lines.sorted { (line1, line2) -> Bool in
            return line1.number > line2.number
        }
        .first
        .map { $0.maxY }
        
        return CGSize(width: collectionViewWidth, height: height ?? 0.0)
    }
    
    func reset() {
        lines = []
    }
}
