//
//  XibInitializable.swift
//  RangeSlider
//
//  Created by Takuya Yokoyama on 2017/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import UIKit

protocol RangeSliderViewInitializable: class {}
extension RangeSliderViewInitializable where Self: UIView {
    func setXibView() {
        let bundle = Bundle(for: type(of: self))
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [.top, .bottom, .leading, .trailing].map { (attr: NSLayoutConstraint.Attribute) in
            return NSLayoutConstraint(
                item: view,
                attribute: attr,
                relatedBy: .equal,
                toItem: self,
                attribute: attr,
                multiplier: 1,
                constant: 0
            )
        }
        addConstraints(constraints)
    }
}
