//
//  RowProvider.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/04/09.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import Foundation

protocol RowProvider {
    var layout: PickupLayout? { get set }
    init(layout: PickupLayout)
}

extension RowProvider {
    var columnCount: Int {
        return layout?.columnCount ?? 0
    }
    
    var lineCount: Int {
        return layout?.lineCount ?? 0
    }
    
    var largeItemMultipler: Int {
        return layout?.largeItemMultipler ?? 0
    }
    
    var itemHeight: CGFloat {
        return layout?.itemHeight ?? .leastNormalMagnitude
    }
    
    var largeRowCompactItemCount: Int {
        return layout?.largeRowCompactItemCount ?? 0
    }
    
    func sectionInset(at section: Int) -> UIEdgeInsets {
        return layout?.sectionInset(at: section) ?? .zero
    }
    
    func interItemSpacing(at section: Int) -> CGFloat {
        return layout?.interItemSpacing(at: section) ?? .leastNormalMagnitude
    }
    
    func lineSpacing(at section: Int) -> CGFloat {
        return layout?.lineSpacing(at: section) ?? .leastNormalMagnitude
    }
    
    func currentMaxY(forSectionAt section: Int) -> CGFloat {
        return layout?.currentMaxY(forSectionAt: section) ?? .leastNormalMagnitude
    }
    
    func compactItemWidth(forSectionAt section: Int) -> CGFloat {
        return layout?.compactItemWidth(forSectionAt: section) ?? .leastNormalMagnitude
    }
}

class GridItemRowProvider: RowProvider {
    weak var layout: PickupLayout?
    
    required init(layout: PickupLayout) {
        self.layout = layout
    }
    
    func request(for section: Int) -> [CGRect] {
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
}

class LargeItemRowProvider: RowProvider {
    enum LargeItemPosition {
        case left
        case right
    }
    
    weak var layout: PickupLayout?
    
    required init(layout: PickupLayout) {
        self.layout = layout
    }
    
    func request(for section: Int, position: LargeItemPosition) -> (largeFrame: CGRect, defaultFrames: [CGRect]) {
        let leftInset = sectionInset(at: section).left
        let itemSpacing = interItemSpacing(at: section)
        let lineSpacing = self.lineSpacing(at: section)
        let defaultItemWidth = compactItemWidth(forSectionAt: section)
        
        let largeItemWidth = defaultItemWidth * CGFloat(largeItemMultipler)
        
        let dismissedItemSpaceCount = largeItemMultipler - 1
        let dissmissedTotalitemSpacing = interItemSpacing(at: section) * CGFloat(dismissedItemSpaceCount)
        
        let compactItemColumnCount = columnCount - largeItemMultipler
        
        var largeFrame = CGRect.zero
        switch position {
        case .left: largeFrame.origin.x = leftInset
        case .right: largeFrame.origin.x = leftInset + (defaultItemWidth + itemSpacing) * CGFloat(compactItemColumnCount)
        }
        largeFrame.origin.y = currentMaxY(forSectionAt: section) + lineSpacing
        largeFrame.size.width = largeItemWidth + dissmissedTotalitemSpacing
        largeFrame.size.height = itemHeight * CGFloat(lineCount) + lineSpacing
        
        let defaultFrames = (0..<largeRowCompactItemCount).map { offset -> CGRect in
            let itemOffset = (defaultItemWidth + itemSpacing) * CGFloat(offset % compactItemColumnCount)
            let x: CGFloat
            switch position {
            case .left: x = leftInset + (largeFrame.size.width + itemSpacing) + itemOffset
            case .right: x = leftInset + itemOffset
            }
            let totalLineSpacing = lineSpacing * CGFloat(offset / compactItemColumnCount + 1)
            let y = currentMaxY(forSectionAt: section) + itemHeight * CGFloat(offset / compactItemColumnCount) + totalLineSpacing
            return CGRect(x: x, y: y, width: defaultItemWidth, height: itemHeight)
        }
        
        return (largeFrame: largeFrame, defaultFrames: defaultFrames)
    }
}

class WideItemRowProvider: RowProvider {
    weak var layout: PickupLayout?
    
    required init(layout: PickupLayout) {
        self.layout = layout
    }
    
    func request(for section: Int) -> CGRect {
        let itemSpacing = interItemSpacing(at: section)
        let lineSpacing = self.lineSpacing(at: section)
        return CGRect(
            x: sectionInset(at: section).left,
            y: currentMaxY(forSectionAt: section) + lineSpacing,
            width: compactItemWidth(forSectionAt: section) * CGFloat(columnCount) + (itemSpacing * CGFloat(columnCount - 1)),
            height: itemHeight * CGFloat(lineCount)
        )
    }
}
