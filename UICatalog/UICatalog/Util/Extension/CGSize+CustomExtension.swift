//
//  CGSize+CustomExtension.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/26.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension CGSize {
    public static func random(min: CGFloat, max: CGFloat) -> CGSize {
        let diff = UInt32(max - min)
        let width = CGFloat(arc4random_uniform(diff)) + min
        let height = CGFloat(arc4random_uniform(diff)) + min
        return CGSize(width: width, height: height)
    }
}
