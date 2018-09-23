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
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    public init() {
        self.init(frame: .zero)
    }
    
}

