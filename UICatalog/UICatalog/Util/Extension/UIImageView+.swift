//
//  UIImageView+.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/12/08.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension UIImageView {
    public func setImageWithFadeInAnimation(_ image: UIImage) {
        self.image = image
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.layer.add(transition, forKey: nil)
    }
}
