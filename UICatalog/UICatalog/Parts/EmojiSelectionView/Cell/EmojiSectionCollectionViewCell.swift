//
//  EmojiSectionCollectionViewCell.swift
//  EmojiCollectionView
//
//  Created by Takuya Yokoyama on 2019/06/03.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class EmojiSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.rounded()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            button.backgroundColor = isSelected ? UIColor(white: 0.0, alpha: 0.1) : .clear
        }
    }
    
    @discardableResult
    func setting(title: String) -> Self {
        button.setTitle(title, for: .normal)
        return self
    }
}
