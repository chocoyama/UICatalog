//
//  AdaptiveItemWidthLayoutable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol AdaptiveItemWidthLayoutable: class {
    var collectionView: UICollectionView! { get }
    func sizeForItem(at indexPath: IndexPath) -> CGSize
}
