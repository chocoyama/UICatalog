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
    func overlay(on view: UIView) {
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
    func round() -> Self {
        layer.cornerRadius = bounds.width / 2.0
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func round(cornerRadius: CGFloat) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func drawBorder(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func addDropShadow(offset: CGFloat, opacity: Float, radius: CGFloat) -> Self {
        layer.shadowOffset = CGSize(width: offset, height: offset)
        layer.shadowOpacity = opacity
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        return self
    }
}
