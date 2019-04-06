//
//  PanelLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol PanelLayoutDelegate: class {
    func indexPathsForPickupItem(_ panelLayout: PanelLayout) -> [IndexPath]?
    func panelLayout(_ panelLayout: PanelLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func panelLayout(_ panelLayout: PanelLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func panelLayout(_ panelLayout: PanelLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

open class PanelLayout: UICollectionViewLayout {
    enum Mode {
        case pickup
        case inOrder
    }
    
    open weak var delegate: PanelLayoutDelegate?
    
    private let columnCount = 3
    private let lineCount = 2
    private let itemHeight: CGFloat
    
    private var mode: Mode = .inOrder
    private var attributesSet = [UICollectionViewLayoutAttributes]()
    private var preservedIndexPaths: [IndexPath] = []
    private var pickupIndexPaths: [IndexPath] = []
    private var pendingPickupIndexPaths: [IndexPath] = []
    private var previousRowType: RowType = .wide
    private var previousLargeRowType: RowType?
    private var currentRowType: RowType = .grid
    
    open func reset() {
        attributesSet = []
        preservedIndexPaths = []
        pickupIndexPaths = []
        pendingPickupIndexPaths = []
        previousRowType = .wide
        previousLargeRowType = nil
        currentRowType = .grid
    }
    
    public init(itemHeight: CGFloat) {
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
                    case .grid:
                        gridItemFrames(forSectionAt: section).enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths[$0.offset])
                            attributes.frame = $0.element
                            attributesSet.append(attributes)
                        }
                        preservedIndexPaths = []
                    case .leftLarge:
                        let frames = largeItemFrames(at: .left, forSectionAt: section)
                        let largeIndexPath: IndexPath
                        switch mode {
                        case .pickup: largeIndexPath = pendingPickupIndexPaths.removeFirst()
                        case .inOrder: largeIndexPath = preservedIndexPaths.removeFirst()
                        }
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        (0...1).map { preservedIndexPaths[$0] }.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                        preservedIndexPaths = []
                    case .rightLarge:
                        let frames = largeItemFrames(at: .right, forSectionAt: section)
                        let largeIndexPath: IndexPath
                        switch mode {
                        case .pickup: largeIndexPath = pendingPickupIndexPaths.removeFirst()
                        case .inOrder: largeIndexPath = preservedIndexPaths.removeFirst()
                        }
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        (0...1).map { preservedIndexPaths[$0] }.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                        preservedIndexPaths = []
                    case .wide:
                        let indexPath: IndexPath
                        switch mode {
                        case .pickup: indexPath = pendingPickupIndexPaths.removeFirst()
                        case .inOrder: indexPath = preservedIndexPaths.removeFirst()
                        }
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = wideFrame(forSectionAt: section)
                        attributesSet.append(attributes)
                    }
                    changeRowType(to: nextRowType)
                }
            }
            
            if !preservedIndexPaths.isEmpty {
                let willAppearEmptySpace = preservedIndexPaths.count % columnCount != 0
                if willAppearEmptySpace {
                    preservedIndexPaths.enumerated().forEach {
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                        attributes.frame = wideFrame(forSectionAt: section)
                        attributesSet.append(attributes)
                    }
                } else {
                    let frames = gridItemFrames(forSectionAt: section)
                    preservedIndexPaths.enumerated().forEach {
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                        attributes.frame = frames[$0.offset]
                        attributesSet.append(attributes)
                    }
                }
                preservedIndexPaths = []
            }
            
            if !pendingPickupIndexPaths.isEmpty {
                pendingPickupIndexPaths.forEach {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: $0)
                    attributes.frame = wideFrame(forSectionAt: section)
                    attributesSet.append(attributes)
                }
                pendingPickupIndexPaths = []
            }
            
            previousLargeRowType = .wide
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

extension PanelLayout {
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
            var threshold = largeRowTotalItemCount
            if case .pickup = mode {
                threshold -= 1
            }
            return preservedIndexPaths.count >= threshold && pendingPickupIndexPaths.count >= 1
        case .wide:
            return true
        }
    }
    
    private var largeRowTotalItemCount: Int {
        return (columnCount * lineCount) - ((columnCount - 1) * lineCount - 1)
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

extension PanelLayout {
    enum LargeItemPosition {
        case left
        case right
    }
    
    private func sectionInset(at section: Int) -> UIEdgeInsets {
        return delegate?.panelLayout(self, insetForSectionAt: section) ?? .zero
    }
    
    private func interItemSpacing(at section: Int) -> CGFloat {
        return delegate?.panelLayout(self, minimumInteritemSpacingForSectionAt: section) ?? .leastNormalMagnitude
    }
    
    private func lineSpacing(at section: Int) -> CGFloat {
        return delegate?.panelLayout(self, minimumLineSpacingForSectionAt: section) ?? .leastNormalMagnitude
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView?.frame.width ?? .leastNormalMagnitude
    }
    
    private func compactItemWidth(forSectionAt section: Int) -> CGFloat {
        let horizontalTotalSectionInset = sectionInset(at: section).left + sectionInset(at: section).right
        let totalInterItemSpacing = interItemSpacing(at: section) * CGFloat(columnCount - 1)
        
        let totalHorizontalMargin = horizontalTotalSectionInset + totalInterItemSpacing
        
        return (collectionViewWidth - totalHorizontalMargin) / CGFloat(columnCount)
    }
    
    private func currentMaxY(forSectionAt section: Int) -> CGFloat {
        return attributesSet.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
        }?.frame.maxY ?? (sectionInset(at: section).top - lineSpacing(at: section))
    }
    
    private func gridItemFrames(forSectionAt section: Int) -> [CGRect] {
        let leftInset = sectionInset(at: section).left
        let lineSpacing = self.lineSpacing(at: section)
        return (0..<(columnCount * lineCount)).map {
            let totalItemSpacing = interItemSpacing(at: section) * CGFloat($0 % columnCount)
            return CGRect(
                x: compactItemWidth(forSectionAt: section) * CGFloat($0 % columnCount) + leftInset + totalItemSpacing,
                y: currentMaxY(forSectionAt: section) + itemHeight * CGFloat($0 / columnCount) + lineSpacing * CGFloat($0 / columnCount + 1),
                width: compactItemWidth(forSectionAt: section),
                height: itemHeight
            )
        }
    }
    
    private func largeItemFrames(at position: LargeItemPosition, forSectionAt section: Int) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        let leftInset = sectionInset(at: section).left
        let itemSpacing = interItemSpacing(at: section)
        let lineSpacing = self.lineSpacing(at: section)
        
        var largeFrame = CGRect.zero
        largeFrame.origin.y = currentMaxY(forSectionAt: section) + lineSpacing
        largeFrame.size.width = compactItemWidth(forSectionAt: section) * CGFloat(columnCount - 1) + itemSpacing
        largeFrame.size.height = itemHeight * CGFloat(lineCount) + lineSpacing
        
        let defaultFramesX: CGFloat
    
        switch position {
        case .left:
            largeFrame.origin.x = leftInset
            defaultFramesX = largeFrame.size.width + leftInset + itemSpacing
        case .right:
            largeFrame.origin.x = compactItemWidth(forSectionAt: section) + leftInset + itemSpacing
            defaultFramesX = leftInset
        }
        
        let defaultFrames = (0...1).map {
            CGRect(
                x: defaultFramesX,
                y: currentMaxY(forSectionAt: section) + itemHeight * CGFloat($0) + lineSpacing * CGFloat($0 + 1),
                width: compactItemWidth(forSectionAt: section),
                height: itemHeight
            )
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
    
    private func wideFrame(forSectionAt section: Int) -> CGRect {
        let itemSpacing = interItemSpacing(at: section)
        let lineSpacing = self.lineSpacing(at: section)
        return CGRect(
            x: sectionInset(at: section).left,
            y: currentMaxY(forSectionAt: section) + lineSpacing,
            width: compactItemWidth(forSectionAt: section) * CGFloat(columnCount) + (itemSpacing * 2),
            height: itemHeight * CGFloat(lineCount)
        )
    }
}
