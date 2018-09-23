//
//  Color+CustomExtension.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/02.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension UIColor {
    convenience public init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience public init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
