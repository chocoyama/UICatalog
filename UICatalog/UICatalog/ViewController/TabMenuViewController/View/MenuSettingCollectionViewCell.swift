//
//  MenuSettingCollectionViewCell.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class MenuSettingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    @discardableResult
    func configure(configuration: TabMenuConfiguration.SettingIcon) -> Self {
        rounded()
        adjustImageSize()
        imageView.image = configuration.menuColor.image
        contentView.backgroundColor = configuration.backgroundColor
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
