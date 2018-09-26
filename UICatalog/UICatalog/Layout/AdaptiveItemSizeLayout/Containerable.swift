//
//  Containerable.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol Containerable {
    func setCollectionViewFrame(_ frame: CGRect)
    func addAttributes(indexPath: IndexPath, itemSize: CGSize)
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func reset()
}
