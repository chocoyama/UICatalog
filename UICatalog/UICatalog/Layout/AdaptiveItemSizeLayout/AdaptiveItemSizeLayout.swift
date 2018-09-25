//
//  AdaptiveItemSizeLayout.swift
//  AdaptiveItemSizeLayout
//
//  Created by 横山 拓也 on 2016/03/30.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemSizeLayout: UICollectionViewLayout {
    public struct Configuration {
        public var columnCount: Int
        public var minColumnCount: Int
        public var maxColumnCount: Int
        public var minimumInterItemSpacing: CGFloat
        public var minimumLineSpacing: CGFloat
        public var sectionInsets: UIEdgeInsets
        
        public init(
            columnCount: Int = 2,
            minColumnCount: Int = 1,
            maxColumnCount: Int = Int.max,
            minimumInterItemSpacing: CGFloat = 5.0,
            minimumLineSpacing: CGFloat = 10.0,
            sectionInsets: UIEdgeInsets = .zero
        ) {
            self.columnCount = columnCount
            self.minColumnCount = minColumnCount
            self.maxColumnCount = maxColumnCount
            self.minimumInterItemSpacing = minimumInterItemSpacing
            self.minimumLineSpacing = minimumLineSpacing
            self.sectionInsets = sectionInsets
        }
        
        public var atMaxColumn: Bool {
            return (columnCount == maxColumnCount)
        }
        
        public var atMinColumn: Bool {
            return (columnCount == minColumnCount)
        }
        
        public var totalSpace: Int {
            return columnCount - 1
        }
        
        public var itemWidth: CGFloat {
            let totalHorizontalInsets = sectionInsets.left + sectionInsets.right
            let totalInterItemSpace = minimumInterItemSpacing * CGFloat(totalSpace)
            let itemWidth = (UIScreen.main.bounds.width - totalHorizontalInsets - totalInterItemSpace) / CGFloat(columnCount)
            return itemWidth
        }
        
        public func itemHeight(rawItemSize: CGSize) -> CGFloat {
            let itemHeight = rawItemSize.height * itemWidth / rawItemSize.width
            return itemHeight
        }
    }
    
    open weak var delegate: AdaptiveItemSizeLayoutable?
    
    open var configuration = Configuration()
    private var columnContainer: ColumnContainer
    
    public init(configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        self.columnContainer = ColumnContainer(configuration: self.configuration)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.columnContainer = ColumnContainer(configuration: self.configuration)
        super.init(coder: aDecoder)
    }
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        reset()
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.sizeForItem(at: indexPath) ?? CGSize.zero
                columnContainer.addAttributes(indexPath: indexPath, itemSize: itemSize)
            }
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return columnContainer.all.flatMap { $0.getAttributes(rect: rect) }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return columnContainer.all.compactMap { $0.getAttributes(indexPath: indexPath as NSIndexPath) }.first
    }
    
    override open var collectionViewContentSize: CGSize {
        let width = collectionView?.bounds.width ?? CGFloat.leastNormalMagnitude
        let height = columnContainer.bottom
        return CGSize(width: width, height: height)
    }
    
    private func reset() {
        columnContainer.reset()
    }
}
