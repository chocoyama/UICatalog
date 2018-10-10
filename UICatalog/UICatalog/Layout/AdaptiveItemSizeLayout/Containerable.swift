//
//  Containerable.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol Containerable {
    var headers: [Header] { get }
    var lines: [Line] { get set }
    func configure(by collectionView: UICollectionView)
    func addItem(indexPath: IndexPath, itemSize: CGSize)
    func addHeader(section: Int, size: CGSize)
    func collectionViewContentSize(by collectionViewWidth: CGFloat) -> CGSize
    func reset(by collectionView: UICollectionView)
    func finish()
}

extension Containerable {
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headers = self.headers.flatMap { $0.getAttributes(rect: rect) }
        let lines = self.lines.flatMap { $0.getAttributes(rect: rect) }
        return headers + lines
    }

    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return lines.compactMap { $0.getAttributes(indexPath: indexPath) }.first
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return headers.first(where: { $0.section == indexPath.section })?.attributes
    }
}
