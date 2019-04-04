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
    private let itemWidth: CGFloat
    
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
    
    public init(itemHeight: CGFloat, collectionViewWidth: CGFloat) {
        self.itemHeight = itemHeight
        self.itemWidth = collectionViewWidth / CGFloat(columnCount)
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
                        gridItemFrames().enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths[$0.offset])
                            attributes.frame = $0.element
                            attributesSet.append(attributes)
                        }
                    case .leftLarge:
                        let frames = largeItemFrames(at: .left)
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
                        let frames = largeItemFrames(at: .right)
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
                        attributes.frame = wideFrame()
                        attributesSet.append(attributes)
                    }
                    preservedIndexPaths = []
                    changeRowType()
                }
            }
        }
        
        if !preservedIndexPaths.isEmpty {
            let willAppearEmptySpace = !pickupIndexPaths.isEmpty && preservedIndexPaths.count % columnCount != 0
            if willAppearEmptySpace {
                preservedIndexPaths.enumerated().forEach {
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                    attributes.frame = wideFrame()
                    attributesSet.append(attributes)
                }
            } else {
                let frames = gridItemFrames()
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
                attributes.frame = wideFrame()
                attributesSet.append(attributes)
            }
            pickupIndexPaths = []
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return getAttributes(in: rect)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return getAttributes(at: indexPath)
    }
    
    open override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0,
                      height: currentMaxY)
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
    
    private var currentMaxY: CGFloat {
        return attributesSet.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
            }?.frame.maxY ?? 0
    }
    
    private func gridItemFrames() -> [CGRect] {
        return (0..<(columnCount * lineCount)).map {
            CGRect(
                x: itemWidth * CGFloat($0 % columnCount),
                y: currentMaxY + itemHeight * CGFloat($0 / columnCount),
                width: itemWidth,
                height: itemHeight
            )
        }
    }
    
    private func largeItemFrames(at position: LargeItemPosition) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        var largeFrame = CGRect.zero
        largeFrame.origin.y = currentMaxY
        largeFrame.size.width = itemWidth * CGFloat(columnCount - 1)
        largeFrame.size.height = itemHeight * CGFloat(lineCount)
        
        let defaultFramesX: CGFloat
        
        switch position {
        case .left:
            largeFrame.origin.x = 0
            defaultFramesX = largeFrame.size.width
        case .right:
            largeFrame.origin.x = itemWidth
            defaultFramesX = 0
        }
        
        let defaultFrames = (0...1).map {
            CGRect(
                x: defaultFramesX,
                y: currentMaxY + itemHeight * CGFloat($0),
                width: itemWidth,
                height: itemHeight
            )
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
    
    private func wideFrame() -> CGRect {
        return CGRect(
            x: 0,
            y: currentMaxY,
            width: itemWidth * CGFloat(columnCount),
            height: itemHeight * CGFloat(lineCount)
        )
    }
}
