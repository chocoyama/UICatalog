//
//  Item.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/27.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol Line {
    var section: Int { get }
    var number: Int { get }
    var maxX: CGFloat { get }
    var maxY: CGFloat { get }
    var originX: CGFloat { get }
    var originY: CGFloat { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var attributesSet: [UICollectionViewLayoutAttributes] { get set }
    func addAttributes(indexPath: IndexPath, itemSize: CGSize)
    func getAttributes(indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func getAttributes(rect: CGRect) -> [UICollectionViewLayoutAttributes]
    func update(addingBottom: CGFloat)
}

extension Line {
    func getAttributes(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesSet.filter {
            let equalSection = $0.indexPath.section == indexPath.section
            let equalItem = $0.indexPath.item == indexPath.item
            return equalSection && equalItem
        }.first
    }
    
    func getAttributes(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        return attributesSet.filter { $0.frame.intersects(rect) }
    }
}
