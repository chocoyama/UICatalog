//
//  RowContainer.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension AdaptiveItemWidthLayout {
    class RowContainer {
        private var rows = [Row]()
        private let configuration: AdaptiveItemWidthLayout.Configuration
        private var collectionViewWidth: CGFloat = .leastNormalMagnitude

        init(configuration: AdaptiveItemWidthLayout.Configuration) {
            self.configuration = configuration
        }
        
        var collectionViewContentSize: CGSize {
            let height = rows.sorted { (row1, row2) -> Bool in return row1.rowNumber > row2.rowNumber }
                             .first
                             .map { $0.maxY }
            return CGSize(width: collectionViewWidth, height: height ?? 0.0)
        }
        
        private var limitX: CGFloat {
            return collectionViewWidth - configuration.sectionInsets.right
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
        
        func setCollectionViewWidth(_ width: CGFloat) {
            self.collectionViewWidth = width
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
}
