//
//  AdaptiveItemHeightLayoutConfiguration.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public struct AdaptiveHeightConfiguration: Equatable {
    public var columnCount: Int
    public var minColumnCount: Int
    public var maxColumnCount: Int
    public var minimumInterItemSpacing: CGFloat
    public var minimumLineSpacing: CGFloat
    public var sectionInsets: UIEdgeInsets
    
    public static var `default`: AdaptiveHeightConfiguration {
        return AdaptiveHeightConfiguration()
    }
    
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
}

