//
//  UIView+CustomExtension.swift
//  MiseryPot
//
//  Created by takyokoy on 2017/12/27.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

// MARK:- Layout
extension UIView {
    public func overlay(on view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK:- Design
extension UIView {
    @discardableResult
    public func rounded() -> Self {
        layer.cornerRadius = bounds.width / 2.0
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    public func rounded(cornerRadius: CGFloat, cornerMasks: CACornerMask = []) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        if !cornerMasks.isEmpty {
            layer.maskedCorners = cornerMasks
        }
        
        return self
    }
    
    @discardableResult
    public func drawBorder(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    public func addDropShadow(offsetSize: CGSize,
                              opacity: Float,
                              radius: CGFloat,
                              color: UIColor) -> Self {
        layer.shadowOffset = offsetSize
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        return self
    }
}

// MARK:- State
extension UIView {
    public func toggle(isHidden: Bool? = nil) {
        if let isHidden = isHidden {
            self.isHidden = isHidden
        } else {
            self.isHidden = !self.isHidden
        }
    }
}
