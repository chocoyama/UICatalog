//
//  ImageDetailCollectionViewCell.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/12/08.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ImageDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @discardableResult
    func configure(for image: UIImage) -> Self {
        imageView.image = image
        return self
    }

}
