//
//  XibInitializable.swift
//  MiseryPot
//
//  Created by takyokoy on 2017/12/26.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

/**
 1. 以下のイニシャライザを実装
 ```
 required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setXibView()
 }
 
 override init(frame: CGRect) {
    super.init(frame: frame)
    setXibView()
 }
 ```
 
 2. コードで生成する場合は、以下の呼び出しを行う。
 ```
 let view = SomeInitializableView.create()
 ```
 */
public protocol XibInitializable: class {}
extension XibInitializable where Self: UIView {
    public func setXibView() {
        let nib = UINib(nibName: String(describing: Self.self), bundle: Bundle(for: type(of: self)))
        let xibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.insertSubview(xibView, at: 0)
        xibView.overlay(on: self)
//        self.backgroundColor = .clear
    }
    
    public init() {
        self.init(frame: .zero)
    }
    
}

