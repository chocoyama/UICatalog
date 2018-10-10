//
//  AdaptiveItemWidthCollectionReusableView.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/09.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class AdaptiveItemWidthCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func configure(title: String) -> AdaptiveItemWidthCollectionReusableView {
        self.label.text = title
        return self
    }
    
}
