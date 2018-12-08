//
//  ImageDetailThumbnailCollectionViewCell.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/12/07.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ImageDetailThumbnailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @discardableResult
    func configure(for image: UIImage) -> Self {
        imageView.image = image
        return self
    }
    
}
