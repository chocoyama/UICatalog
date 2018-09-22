//
//  Painter.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/22.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class Painter {
    class func paintRadialGradient(to view: UIView, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = GradientLayer(startColor: startColor, endColor: endColor)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
}

extension Painter {
    class GradientLayer: CALayer {
        private let startColor: UIColor
        private let endColor: UIColor
        
        init(startColor: UIColor, endColor: UIColor) {
            self.startColor = startColor
            self.endColor = endColor
            super.init()
            setNeedsDisplay()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(in ctx: CGContext) {
            ctx.saveGState()
            
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [startColor.cgColor, endColor.cgColor] as CFArray,
                locations: [0.0, 1.0]
                )!
            
            ctx.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2),
                startRadius: 0.0,
                endCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2),
                endRadius: min(self.bounds.size.width, self.bounds.size.height),
                options: []
            )
            
            ctx.restoreGState()
        }
    }
    
}

