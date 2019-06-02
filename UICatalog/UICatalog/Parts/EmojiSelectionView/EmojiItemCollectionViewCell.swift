//
//  NumberingCollectionViewCell.swift
//  EmojiCollectionView
//
//  Created by Takuya Yokoyama on 2019/06/03.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class EmojiItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func setting(emoji: String, fontSize: CGFloat) -> Self {
        label.text = emoji
        label.font = label.font.withSize(fontSize)
        return self
    }
    
}
