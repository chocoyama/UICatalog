//
//  Header.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/09.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public struct Header {
    let section: Int
    var frame: CGRect
    let attributes: UICollectionViewLayoutAttributes
    
    init(section: Int, size: CGSize) {
        self.section = section
        self.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: size.width,
            height: size.height
        )
        self.attributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            with: IndexPath(item: 0, section: section)
        )
    }
    
    mutating func update(originY: CGFloat) {
        frame.origin.y = originY
    }
}
