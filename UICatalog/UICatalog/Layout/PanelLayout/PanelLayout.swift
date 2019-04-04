//
//  PanelLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol PanelLayoutDelegate: class {
    func panelLayout(_ panelLayout: PanelLayout, shouldPickUpItemAt indexPath: IndexPath) -> Bool
}

open class PanelLayout: UICollectionViewLayout {
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
    
    open weak var delegate: PanelLayoutDelegate?
    
    private let columnCount = 3
    private let lineCount = 2
    private let itemHeight: CGFloat
    private let itemWidth: CGFloat
    
    private var attributesSet = [UICollectionViewLayoutAttributes]()
    private var preservedIndexPaths: [IndexPath] = []
    
    private var previousRowType: RowType = .wide
    private var currentRowType: RowType = .grid
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
    
    private func changeRowType() {
        let nextRowType = self.nextRowType
        previousRowType = currentRowType
        currentRowType = nextRowType
    }
    
    private var currentMaxY: CGFloat {
        return attributesSet.max { (attr1, attr2) -> Bool in
            return attr1.frame.maxY < attr2.frame.maxY
        }?.frame.maxY ?? 0
    }
    
    public init(itemHeight: CGFloat, collectionViewWidth: CGFloat) {
        self.itemHeight = itemHeight
        self.itemWidth = collectionViewWidth / CGFloat(columnCount)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gridItemFrames(columnCount: Int = 3, lineCount: Int = 2) -> [CGRect] {
        return (0..<(columnCount * lineCount)).map {
            CGRect(
                x: itemWidth * CGFloat($0 % columnCount),
                y: currentMaxY + itemHeight * CGFloat($0 / columnCount),
                width: itemWidth,
                height: itemHeight
            )
        }
    }
    
    private func leftLargeItemFrames(columnCount: Int = 3, lineCount: Int = 2) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        let largeFrame = CGRect(
            x: 0,
            y: currentMaxY,
            width: itemWidth * CGFloat(columnCount - 1),
            height: itemHeight * CGFloat(lineCount)
        )
        
        let defaultFrames = (0...1).map {
            CGRect(
                x: itemWidth * CGFloat(columnCount - 1),
                y: currentMaxY + itemHeight * CGFloat($0),
                width: itemWidth,
                height: itemHeight
            )
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
    
    private func rightLargeItemFrames(columnCount: Int = 3, lineCount: Int = 2) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        let largeFrame = CGRect(
            x: itemWidth,
            y: currentMaxY,
            width: itemWidth * CGFloat(columnCount - 1),
            height: itemHeight * CGFloat(lineCount)
        )
        
        let defaultFrames = (0...1).map {
            CGRect(
                x: 0,
                y: currentMaxY + itemHeight * CGFloat($0),
                width: itemWidth,
                height: itemHeight
            )
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
    
    private func wideFrame(columnCount: Int = 3, lineCount: Int = 2) -> CGRect {
        return CGRect(
            x: 0,
            y: currentMaxY,
            width: itemWidth * CGFloat(columnCount),
            height: itemHeight * CGFloat(lineCount)
        )
    }
    
    private var largeRowTotalItemCount: Int {
        return (columnCount * lineCount) - ((columnCount - 1) * lineCount - 1)
    }
    
    private var shouldSetAttributes: Bool {
        switch nextRowType {
        case .grid:
            return preservedIndexPaths.count == columnCount * lineCount
        case .leftLarge, .rightLarge:
            return preservedIndexPaths.count == largeRowTotalItemCount
        case .wide:
            return preservedIndexPaths.count == 1
        }
    }
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView, let delegate = delegate else { return }
        
        for section in (0..<collectionView.numberOfSections) {
            for item in (0..<collectionView.numberOfItems(inSection: section)) {
                preservedIndexPaths.append(IndexPath(item: item, section: section))
                
                if shouldSetAttributes {
                    switch nextRowType {
                    case .grid:
                        let frames = gridItemFrames(columnCount: columnCount, lineCount: lineCount)
                        frames.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths[$0.offset])
                            attributes.frame = $0.element
                            attributesSet.append(attributes)
                        }
                    case .leftLarge:
                        let frames = leftLargeItemFrames(columnCount: columnCount, lineCount: lineCount)
                        let largeIndexPath = preservedIndexPaths.remove(at: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        preservedIndexPaths.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                    case .rightLarge:
                        let frames = rightLargeItemFrames(columnCount: columnCount, lineCount: lineCount)
                        
                        let largeIndexPath = preservedIndexPaths.remove(at: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: largeIndexPath)
                        attributes.frame = frames.largeFrame
                        attributesSet.append(attributes)
                        
                        preservedIndexPaths.enumerated().forEach {
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                            attributes.frame = frames.defaultFrames[$0.offset]
                            attributesSet.append(attributes)
                        }
                    case .wide:
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: preservedIndexPaths.first!)
                        attributes.frame = wideFrame(columnCount: columnCount, lineCount: lineCount)
                        attributesSet.append(attributes)
                    }
                    preservedIndexPaths = []
                    changeRowType()
                }
            }
        }
        
        if !preservedIndexPaths.isEmpty {
            let frames = gridItemFrames(columnCount: columnCount, lineCount: lineCount)
            preservedIndexPaths.enumerated().forEach {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: $0.element)
                attributes.frame = frames[$0.offset]
                attributesSet.append(attributes)
            }
            preservedIndexPaths = []
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
