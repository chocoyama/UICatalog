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
        
        private func getCapableRow(nextItemSize: CGSize) -> Row {
            let limitX = collectionViewWidth - configuration.sectionInsets.right
            if let capableRow = rows.filter({ $0.maxX + nextItemSize.width <= limitX }).first {
                return capableRow
            } else {
                let newRow = Row(configuration: configuration, rowNumber: rows.count)
                rows.append(newRow)
                return newRow
            }
        }
        
        func setCollectionViewWidth(_ width: CGFloat) {
            self.collectionViewWidth = width
        }
        
        func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
            let capableRow = getCapableRow(nextItemSize: itemSize)
            capableRow.addAttributes(indexPath: indexPath, itemSize: itemSize)
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
