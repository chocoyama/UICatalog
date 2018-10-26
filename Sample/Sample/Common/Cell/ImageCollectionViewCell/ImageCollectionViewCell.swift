//
//  ImageCollectionViewCell.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/26.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @discardableResult
    func configure(image: UIImage) -> Self {
        self.imageView.image = image
        return self
    }

}
