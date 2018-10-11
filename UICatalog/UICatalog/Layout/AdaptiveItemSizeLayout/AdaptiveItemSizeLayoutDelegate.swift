//
//  AdaptiveItemWidthLayoutable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol AdaptiveItemSizeLayoutDelegate: class {
    var collectionView: UICollectionView! { get }
    func adaptiveItemSizeLayout(_ layout: AdaptiveItemSizeLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func adaptiveItemSizeLayout(_ layout: AdaptiveItemSizeLayout, referenceSizeForHeaderIn section: Int) -> CGSize
}

extension AdaptiveItemSizeLayoutDelegate {
    public func adaptiveItemSizeLayout(_ layout: AdaptiveItemSizeLayout, referenceSizeForHeaderIn section: Int) -> CGSize {
        return .zero
    }
    
    func getAdaptiveItemSizeLayout() -> AdaptiveItemSizeLayout? {
        return collectionView.collectionViewLayout as? AdaptiveItemSizeLayout
    }
}
