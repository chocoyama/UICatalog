//
//  PanelLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol PickupLayoutDelegate: class {
    func indexPathsForPickupItem(_ pickupLayout: PickupLayout) -> [IndexPath]?
    func pickupLayout(_ pickupLayout: PickupLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func pickupLayout(_ pickupLayout: PickupLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func pickupLayout(_ pickupLayout: PickupLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

open class PickupLayout: UICollectionViewLayout {
    enum Mode {
        case pickup
        case inOrder
    }
    
    open weak var delegate: PickupLayoutDelegate?
    
    let columnCount: Int
    let lineCount: Int
    let largeItemMultipler: Int
    let itemHeight: CGFloat
    
    private var largeRowTotalItemCount: Int {
        let dismissedCount = (largeItemMultipler * lineCount) - 1
        return (columnCount * lineCount) - dismissedCount
    }
    
    var largeRowCompactItemCount: Int {
        return largeRowTotalItemCount - 1
    }
    
    private var mode: Mode = .inOrder
    private var attributesSet = [UICollectionViewLayoutAttributes]()
    private var preservedIndexPaths: [IndexPath] = []
    private var pickupIndexPaths: [IndexPath] = []
    private var pendingPickupIndexPaths: [IndexPath] = []
    private var previousRowType: RowType = .wide
    private var previousLargeRowType: RowType?
    private var currentRowType: RowType = .grid
    
    private lazy var gridItemRowProvider: GridItemRowProvider = {
        return GridItemRowProvider(layout: self)
    }()
    private lazy var largeItemRowProvider: LargeItemRowProvider = {
        return LargeItemRowProvider(layout: self)
    }()
    private lazy var wideItemRowProvider: WideItemRowProvider = {
        return WideItemRowProvider(layout: self)
    }()
    
    open func reset() {
        attributesSet = []
        preservedIndexPaths = []
        pickupIndexPaths = []
        pendingPickupIndexPaths = []
        previousRowType = .wide
        previousLargeRowType = nil
        currentRowType = .grid
    }
    
    public init(columnCount: Int = 3,
                lineCount: Int = 2,
                largeItemMultipler: Int = 2,
                itemHeight: CGFloat) {
        self.columnCount = columnCount
        self.lineCount = lineCount
        self.largeItemMultipler = largeItemMultipler
        self.itemHeight = itemHeight
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView, let delegate = delegate else { return }
        
        reset()
        
        if let pickupIndexPaths = delegate.indexPathsForPickupItem(self) {
            self.pickupIndexPaths = pickupIndexPaths
            mode = .pickup
        } else {
            mode = .inOrder
        }
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                
                if pickupIndexPaths.contains(indexPath) {
                    pendingPickupIndexPaths.append(indexPath)
                } else {
                    preservedIndexPaths.append(indexPath)
                }
                
                let nextRowType = self.nextRowType
                if shouldSetAttributes {
                    switch nextRowType {
                    case .grid: appendGridRow(for: section)
                    case .leftLarge: appendLeftLargeRow(for: section)
                    case .rightLarge: appendRightLargeRow(for: section)
                    case .wide: appendWideRow(for: section)
                    }
                    changeRowType(to: nextRowType)
                }
            }
            appendRemainingItemsIfNeeded(for: section)
            appendRemainingPickupItemsIfNeeded(for: section)
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return getAttributes(in: rect)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return getAttributes(at: indexPath)
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let height = (0..<collectionView.numberOfSections).reduce(0) { (total, section) -> CGFloat in
            return total + currentMaxY(forSectionAt: section) + sectionInset(at: section).bottom
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    private func getAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        return attributesSet.filter { $0.frame.intersects(rect) }
    }
    
    private func getAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesSet.filter {
            let equalSection = $0.indexPath.section == indexPath.section
            let equalItem = $0.indexPath.item == indexPath.item
            return equalSection && equalItem
        }.first
    }
}

extension PickupLayout {
    enum RowType: Int {
        case grid
        case leftLarge
        case rightLarge
        case wide
    }
    
    private var nextRowType: RowType {
        if case .pickup = mode, pendingPickupIndexPaths.isEmpty {
            return .grid
        }
        
        switch currentRowType {
        case .grid:
            switch previousRowType {
            case .grid:
                if let previousLargeRowType  = previousLargeRowType {
                    switch previousLargeRowType {
                    case .grid:
                        fatalError()
                    case .leftLarge:
                        return .rightLarge
                    case .rightLarge:
                        return .wide
                    case .wide:
                        return .leftLarge
                    }
                } else {
                  return .leftLarge
                }
            case .leftLarge:
                return .rightLarge
            case .rightLarge:
                return .wide
            case .wide:
                return .leftLarge
            }
        case .leftLarge, .rightLarge, .wide:
            return .grid
        }
    }
    
    private var shouldSetAttributes: Bool {
        switch nextRowType {
        case .grid:
            return preservedIndexPaths.count >= columnCount * lineCount
        case .leftLarge, .rightLarge:
            switch mode {
            case .pickup:
                return preservedIndexPaths.count >= (largeRowTotalItemCount - 1)
                    && pendingPickupIndexPaths.count >= 1
            case .inOrder:
                return preservedIndexPaths.count >= largeRowTotalItemCount
            }
        case .wide:
            return true
        }
    }
    
    private func changeRowType(to nextRowType: RowType) {
        previousRowType = currentRowType
        currentRowType = nextRowType
        
        switch nextRowType {
        case .grid:
            break
        case .leftLarge, .rightLarge, .wide:
            previousLargeRowType = currentRowType
        }
    }
}

extension PickupLayout {
    private func appendGridRow(for section: Int) {
        gridItemRowProvider.request(for: section).enumerated().forEach {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths[$0.offset])
            attributes.frame = $0.element
            attributesSet.append(attributes)
        }
        preservedIndexPaths = []
    }
    
    private func appendLeftLargeRow(for section: Int) {
        let frames = largeItemRowProvider.request(for: section, position: .left)
        let largeIndexPath: IndexPath
        switch mode {
        case .pickup: largeIndexPath = pendingPickupIndexPaths.removeFirst()
        case .inOrder: largeIndexPath = preservedIndexPaths.removeFirst()
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
        attributes.frame = frames.largeFrame
        attributesSet.append(attributes)
        
        (0..<largeRowCompactItemCount).map { preservedIndexPaths[$0] }.enumerated().forEach {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
            attributes.frame = frames.defaultFrames[$0.offset]
            attributesSet.append(attributes)
        }
        preservedIndexPaths = []
    }
    
    private func appendRightLargeRow(for section: Int) {
        let frames = largeItemRowProvider.request(for: section, position: .right)
        let largeIndexPath: IndexPath
        switch mode {
        case .pickup: largeIndexPath = pendingPickupIndexPaths.removeFirst()
        case .inOrder: largeIndexPath = preservedIndexPaths.removeFirst()
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
        attributes.frame = frames.largeFrame
        attributesSet.append(attributes)
        
        (0..<largeRowCompactItemCount).map { preservedIndexPaths[$0] }.enumerated().forEach {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
            attributes.frame = frames.defaultFrames[$0.offset]
            attributesSet.append(attributes)
        }
        preservedIndexPaths = []
    }
    
    private func appendWideRow(for section: Int) {
        let indexPath: IndexPath
        switch mode {
        case .pickup: indexPath = pendingPickupIndexPaths.removeFirst()
        case .inOrder: indexPath = preservedIndexPaths.removeFirst()
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = wideItemRowProvider.request(for: section)
        attributesSet.append(attributes)
    }
    
    private func appendRemainingItemsIfNeeded(for section: Int) {
        guard !preservedIndexPaths.isEmpty else { return }
        let willAppearEmptySpace = preservedIndexPaths.count % columnCount != 0
        if willAppearEmptySpace {
            preservedIndexPaths.enumerated().forEach {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                attributes.frame = wideItemRowProvider.request(for: section)
                attributesSet.append(attributes)
            }
            previousLargeRowType = .wide
        } else {
            let frames = gridItemRowProvider.request(for: section)
            preservedIndexPaths.enumerated().forEach {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                attributes.frame = frames[$0.offset]
                attributesSet.append(attributes)
            }
        }
        preservedIndexPaths = []
    }
    
    private func appendRemainingPickupItemsIfNeeded(for section: Int) {
        guard !pendingPickupIndexPaths.isEmpty else { return }
        pendingPickupIndexPaths.forEach {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0)
            attributes.frame = wideItemRowProvider.request(for: section)
            attributesSet.append(attributes)
        }
        pendingPickupIndexPaths = []
        previousLargeRowType = .wide
    }
}

extension PickupLayout {
    func sectionInset(at section: Int) -> UIEdgeInsets {
        return delegate?.pickupLayout(self, insetForSectionAt: section) ?? .zero
    }
    
    func interItemSpacing(at section: Int) -> CGFloat {
        return delegate?.pickupLayout(self, minimumInteritemSpacingForSectionAt: section) ?? .leastNormalMagnitude
    }
    
    func lineSpacing(at section: Int) -> CGFloat {
        return delegate?.pickupLayout(self, minimumLineSpacingForSectionAt: section) ?? .leastNormalMagnitude
    }
    
    func compactItemWidth(forSectionAt section: Int) -> CGFloat {
        let collectionViewWidth = collectionView?.frame.width ?? .leastNormalMagnitude
        
        let horizontalTotalSectionInset = sectionInset(at: section).left + sectionInset(at: section).right
        let totalInterItemSpacing = interItemSpacing(at: section) * CGFloat(columnCount - 1)
        
        let totalHorizontalMargin = horizontalTotalSectionInset + totalInterItemSpacing
        
        return (collectionViewWidth - totalHorizontalMargin) / CGFloat(columnCount)
    }
    
    func currentMaxY(forSectionAt section: Int) -> CGFloat {
        return attributesSet.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
        }?.frame.maxY ?? (sectionInset(at: section).top - lineSpacing(at: section))
    }
}

