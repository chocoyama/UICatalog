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
    
    var items: [Item] = []
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
    
    private func getCapableRow(nextItemSize: CGSize) -> Item? {
        return items.filter {
            let equalHeight = $0.height == nextItemSize.height
            let overLimit = $0.maxX + nextItemSize.width > limitX
            return equalHeight && !overLimit
        }.first
    }
    
    private func addNewRow(with height: CGFloat) -> Item {
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
    
    func addAttributes(indexPath: IndexPath, itemSize: CGSize) {
        let row: Item
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
