//
//  AdaptiveItemWidthLayoutCollectionViewCell.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/09/26.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func configure(by indexPath: IndexPath, backgroundColor: UIColor) -> LabelCollectionViewCell {
        label.text = "\(indexPath.item)"
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func configure(by text: String, backgroundColor: UIColor) -> LabelCollectionViewCell {
        label.text = text
        self.backgroundColor = backgroundColor
        return self
    }

}
