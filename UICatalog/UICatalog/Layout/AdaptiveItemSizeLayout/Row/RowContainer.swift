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
    
    private var rows = [Row]()
    let configuration: AdaptiveWidthConfiguration
    private var collectionViewWidth: CGFloat = .leastNormalMagnitude
    private var limitX: CGFloat = .leastNormalMagnitude
    
    init(configureBy configuration: Configuration?) {
        self.configuration = configuration ?? Configuration()
    }
    
    private var nextRowOriginY: CGFloat {
        if let lastRow = rows.last {
            return lastRow.maxY + configuration.minimumLineSpacing
        } else {
            return configuration.sectionInsets.top
        }
    }
    
    private func getCapableRow(nextItemSize: CGSize) -> Row? {
        return rows.filter {
            let equalHeight = $0.height == nextItemSize.height
            let overLimit = $0.maxX + nextItemSize.width > limitX
            return equalHeight && !overLimit
            }.first
    }
    
    private func addNewRow(with height: CGFloat) -> Row {
        let newRow = Row(
            configuration: configuration,
            rowNumber: rows.count,
            height: height,
            originY: nextRowOriginY
        )
        rows.append(newRow)
        return newRow
    }
}

extension RowContainer: Containerable {
    func setCollectionViewFrame(_ frame: CGRect) {
        self.collectionViewWidth = frame.width
        self.limitX = frame.width - configuration.sectionInsets.right
    }
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        let row: Row
        if let capableRow = getCapableRow(nextItemSize: itemSize) {
            row = capableRow
        } else {
            row = addNewRow(with: itemSize.height)
        }
        row.addAttributes(indexPath: indexPath, itemSize: itemSize)
    }
    
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize {
        let height = rows.sorted { (row1, row2) -> Bool in return row1.rowNumber > row2.rowNumber }
            .first
            .map { $0.maxY }
        return CGSize(width: collectionViewWidth, height: height ?? 0.0)
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return rows.flatMap { $0.getAttributes(rect: rect) }
    }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return rows.compactMap { $0.getAttributes(indexPath: indexPath) }.first
    }
    
    func reset() {
        rows = []
    }
}
