//
//  Header.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/09.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public class Header {
    let section: Int
    let attributes: UICollectionViewLayoutAttributes
    
    init(section: Int, size: CGSize) {
        self.section = section
        self.attributes = UICollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            with: IndexPath(item: 0, section: section)
        )
        self.attributes.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: size.width,
            height: size.height
        )
    }
    
    func update(originY: CGFloat) {
        attributes.frame.origin.y = originY
    }
    
    func getAttributes(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        return attributes.frame.intersects(rect) ? [attributes] : []
    }
}

public protocol SectionHeaderAppendable {
    var section: Int { get }
    func moveDownward(by point: CGFloat)
}
