//
//  Containerable.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol Containerable {
    var lines: [Line] { get set }
    func configure(by collectionView: UICollectionView)
    func addItem(indexPath: IndexPath, itemSize: CGSize)
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize
    func reset(by collectionView: UICollectionView)
    func finish()
}

extension Containerable {
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return lines.flatMap { $0.getAttributes(rect: rect) }
    }

    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return lines.compactMap { $0.getAttributes(indexPath: indexPath) }.first
    }
}
