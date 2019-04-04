//
//  PanelLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol PanelLayoutDelegate: class {
    func indexPathsForPickupItem(_ panelLayout: PanelLayout) -> [IndexPath]
    func panelLayout(_ panelLayout: PanelLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func panelLayout(_ panelLayout: PanelLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func panelLayout(_ panelLayout: PanelLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

open class PanelLayout: UICollectionViewLayout {
    open weak var delegate: PanelLayoutDelegate?
    
    private let columnCount = 3
    private let lineCount = 2
    private let itemHeight: CGFloat
    
    private var attributesSet = [UICollectionViewLayoutAttributes]()
    private var preservedIndexPaths: [IndexPath] = []
    private var pickupIndexPaths: [IndexPath] = []
    private var previousRowType: RowType = .wide
    private var currentRowType: RowType = .grid
    
    private func reset() {
        attributesSet = []
        preservedIndexPaths = []
        pickupIndexPaths = []
        previousRowType = .wide
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
        pickupIndexPaths = delegate.indexPathsForPickupItem(self)
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                let indexPath = IndexPath(item: item, section: section)
                if pickupIndexPaths.contains(indexPath) {
                    continue
                }
                preservedIndexPaths.append(indexPath)
                
                if shouldSetAttributes {
                    switch nextRowType {
                    case .grid:
                        gridItemFrames(forSectionAt: section).enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths[$0.offset])
                            attributes.frame = $0.element
                            attributesSet.append(attributes)
                        }
                    case .leftLarge:
                        let frames = largeItemFrames(at: .left, forSectionAt: section)
                        let largeIndexPath = pickupIndexPaths.remove(at: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        preservedIndexPaths.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                    case .rightLarge:
                        let frames = largeItemFrames(at: .right, forSectionAt: section)
                        let largeIndexPath = pickupIndexPaths.remove(at: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        preservedIndexPaths.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                    case .wide:
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: pickupIndexPaths.removeFirst())
                        attributes.frame = wideFrame(forSectionAt: section)
                        attributesSet.append(attributes)
                    }
                    preservedIndexPaths = []
                    changeRowType()
                }
            }
            
            if !preservedIndexPaths.isEmpty {
                let willAppearEmptySpace = !pickupIndexPaths.isEmpty && preservedIndexPaths.count % columnCount != 0
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
            
            if !pickupIndexPaths.isEmpty {
                pickupIndexPaths.forEach {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: $0)
                    attributes.frame = wideFrame(forSectionAt: section)
                    attributesSet.append(attributes)
                }
                pickupIndexPaths = []
            }
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
        
        var next: RowType {
            switch self {
            case .grid:
                return RowType(rawValue: (1...3).randomElement()!)!
            case .leftLarge, .rightLarge, .wide:
                return .grid
            }
        }
    }
    
    private var nextRowType: RowType {
        switch currentRowType {
        case .grid:
            switch previousRowType {
            case .grid:
                fatalError()
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
            return preservedIndexPaths.count == columnCount * lineCount
        case .leftLarge, .rightLarge:
            return preservedIndexPaths.count == (largeRowTotalItemCount - 1)
        case .wide:
            return !pickupIndexPaths.isEmpty
        }
    }
    
    private var largeRowTotalItemCount: Int {
        return (columnCount * lineCount) - ((columnCount - 1) * lineCount - 1)
    }
    
    private func changeRowType() {
        let nextRowType = self.nextRowType
        previousRowType = currentRowType
        currentRowType = nextRowType
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
    
    private var collectionViewWidth: CGFloat {
        return collectionView?.frame.width ?? .leastNormalMagnitude
    }
    
    private func itemWidth(forSectionAt section: Int) -> CGFloat {
        let horizontalTotalSectionInset = sectionInset(at: section).left + sectionInset(at: section).right
        let totalInterItemSpacing = interItemSpacing(at: section) * CGFloat(columnCount - 1)
        
        let totalHorizontalMargin = horizontalTotalSectionInset + totalInterItemSpacing
        
        return (collectionViewWidth - totalHorizontalMargin) / CGFloat(columnCount)
    }
    
    private func currentMaxY(forSectionAt section: Int) -> CGFloat {
        return attributesSet.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
        }?.frame.maxY ?? sectionInset(at: section).top
    }
    
    private func gridItemFrames(forSectionAt section: Int) -> [CGRect] {
        return (0..<(columnCount * lineCount)).map {
            CGRect(
                x: itemWidth(forSectionAt: section) * CGFloat($0 % columnCount) + sectionInset(at: section).left,
                y: currentMaxY(forSectionAt: section) + itemHeight * CGFloat($0 / columnCount),
                width: itemWidth(forSectionAt: section),
                height: itemHeight
            )
        }
    }
    
    private func largeItemFrames(at position: LargeItemPosition, forSectionAt section: Int) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        var largeFrame = CGRect.zero
        largeFrame.origin.y = currentMaxY(forSectionAt: section)
        largeFrame.size.width = itemWidth(forSectionAt: section) * CGFloat(columnCount - 1)
        largeFrame.size.height = itemHeight * CGFloat(lineCount)
        
        let defaultFramesX: CGFloat
    
        let leftInset = sectionInset(at: section).left
        switch position {
        case .left:
            largeFrame.origin.x = leftInset
            defaultFramesX = largeFrame.size.width + leftInset
        case .right:
            largeFrame.origin.x = itemWidth(forSectionAt: section) + leftInset
            defaultFramesX = leftInset
        }
        
        let defaultFrames = (0...1).map {
            CGRect(
                x: defaultFramesX,
                y: currentMaxY(forSectionAt: section) + itemHeight * CGFloat($0),
                width: itemWidth(forSectionAt: section),
                height: itemHeight
            )
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
    
    private func wideFrame(forSectionAt section: Int) -> CGRect {
        return CGRect(
            x: sectionInset(at: section).left,
            y: currentMaxY(forSectionAt: section),
            width: itemWidth(forSectionAt: section) * CGFloat(columnCount),
            height: itemHeight * CGFloat(lineCount)
        )
    }
}
