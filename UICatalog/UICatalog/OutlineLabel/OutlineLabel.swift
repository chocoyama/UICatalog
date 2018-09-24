//
//  OutlineLabel.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/24.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class OutlineLabel: UILabel {
    
    @IBInspectable open var outlineColor: UIColor = .white
    @IBInspectable open var outlineWidth: CGFloat = 0.0
    
    override open func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let textColor = self.textColor
        
        context?.setLineWidth(outlineWidth)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        self.textColor = outlineColor
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }

}
