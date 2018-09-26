//
//  AdaptiveSizeCollectionViewCell.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/31.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class AdaptiveSizeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func configure(by indexPath: IndexPath, backgroundColor: UIColor) -> AdaptiveSizeCollectionViewCell {
        self.label.text = "\(indexPath.item)"
        self.backgroundColor = backgroundColor
        return self
    }
}
