//
//  EdgeInsetsLabel.swift
//  YPointAlert
//
//  Created by Takuya Yokoyama on 2018/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import UIKit

@IBDesignable
class CustomEdgeInsetsLabel: UILabel {
    
    @IBInspectable var verticalInset:CGFloat = 2.0
    @IBInspectable var horizontalInset:CGFloat = 4.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        return super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        let width = (size.width > 0) ? size.width + horizontalInset * 2 : size.width
        let height = (size.height > 0) ? size.height + verticalInset * 2 : size.height
     
        return CGSize(width: width, height: height)
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    var customizedFrame: CGRect {
        var newFrame = self.frame
        newFrame.size = self.intrinsicContentSize
        return newFrame.offsetBy(dx: 0, dy: -verticalInset)
    }
}
