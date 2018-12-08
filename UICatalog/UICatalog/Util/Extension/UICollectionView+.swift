//
//  UICollectionView+.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/12/08.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension UICollectionView {
    public var centerIndexPath: IndexPath? {
        let centerPoint = CGPoint(x: self.contentOffset.x + (self.frame.width / 2),
                                  y: self.frame.height / 2)
        return self.indexPathForItem(at: centerPoint)
    }
}
