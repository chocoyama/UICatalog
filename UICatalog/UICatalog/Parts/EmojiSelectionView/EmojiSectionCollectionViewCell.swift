//
//  EmojiSectionCollectionViewCell.swift
//  EmojiCollectionView
//
//  Created by Takuya Yokoyama on 2019/06/03.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class EmojiSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func setting(title: String) -> Self {
        label.text = title
        return self
    }
}
