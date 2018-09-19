//
//  ReusableViewRegisterable.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

protocol ReusableViewRegisterable {}

enum UICollectionElementKind: String {
    case sectionHeader
    case sectionFooter
    
    init(stringOf kind: String) {
        switch kind {
        case UICollectionView.elementKindSectionHeader: self = .sectionHeader
        case UICollectionView.elementKindSectionFooter: self = .sectionFooter
        default: fatalError()
        }
    }
    
    var value: String {
        switch self {
        case .sectionHeader: return UICollectionView.elementKindSectionHeader
        case .sectionFooter: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionReusableView: ReusableViewRegisterable {}
extension ReusableViewRegisterable where Self: UICollectionReusableView {
    static func register(for collectionView: UICollectionView, ofKind kind: UICollectionElementKind) {
        let name = String(describing: Self.self)
        collectionView.register(Self.self, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: name)
    }
    
    static func dequeue(from collectionView: UICollectionView, ofKind kind: UICollectionElementKind, for indexPath: IndexPath) -> Self {
        let name = String(describing: Self.self)
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.value, withReuseIdentifier: name, for: indexPath) as! Self
    }
}

