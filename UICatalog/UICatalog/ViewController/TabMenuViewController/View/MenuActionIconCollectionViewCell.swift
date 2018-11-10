//
//  MenuSettingCollectionViewCell.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class MenuActionIconCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    @discardableResult
    func configure(iconConfiguration: IconConfiguration) -> Self {
        adjustImageSize()
        imageView.image = iconConfiguration.image
        contentView.backgroundColor = iconConfiguration.backgroundColor
        rounded()
        return self
    }
    
    private func adjustImageSize() {
        let constraints = [
            imageViewLeftConstraint,
            imageViewRightConstraint,
            imageViewTopConstraint,
            imageViewBottomConstraint
        ]
        constraints.forEach { $0?.constant = bounds.width / 4 }
    }

}
