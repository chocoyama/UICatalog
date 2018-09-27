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
    
    var items: [Line] = []
    let configuration: AdaptiveWidthConfiguration
    
    private var collectionViewWidth: CGFloat = .leastNormalMagnitude
    private var limitX: CGFloat = .leastNormalMagnitude
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
    }
    
    private var nextRowOriginY: CGFloat {
        if let lastRow = items.last {
            return lastRow.maxY + configuration.minimumLineSpacing
        } else {
            return configuration.sectionInsets.top
        }
    }
    
    private func getCapableRow(nextItemSize: CGSize) -> Line? {
        return items.filter {
            let equalHeight = $0.height == nextItemSize.height
            let overLimit = $0.maxX + nextItemSize.width > limitX
            return equalHeight && !overLimit
        }.first
    }
    
    /// 追加したいCellの高さに適合したItemがない場合、新たにItemを生成する
    ///
    /// - Parameter height: 生成するItemの高さ
    /// - Returns: 生成したItem
    private func addNewRow(with height: CGFloat) -> Line {
        let newRow = Row(
            configuration: configuration,
            rowNumber: items.count,
            height: height,
            originY: nextRowOriginY,
            width: self.collectionViewWidth
        )
        items.append(newRow)
        return newRow
    }
}

extension RowContainer: Containerable {
    func setCollectionViewFrame(_ frame: CGRect) {
        self.collectionViewWidth = frame.width
        self.limitX = frame.width - configuration.sectionInsets.right
    }
    
    func addItem(indexPath: IndexPath, itemSize: CGSize) {
        let row: Line
        if let capableRow = getCapableRow(nextItemSize: itemSize) {
            row = capableRow
        } else {
            row = addNewRow(with: itemSize.height)
        }
        row.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        let height = items.sorted { (row1, row2) -> Bool in
            return row1.number > row2.number
        }
        .first
        .map { $0.maxY }
        
        return CGSize(width: collectionViewWidth, height: height ?? 0.0)
    }
    
    func reset() {
        items = []
    }
}
