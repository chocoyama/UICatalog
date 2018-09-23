//
//  NibInstantiatable.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol NibInstantiatable {}

extension NibInstantiatable where Self: NSObject {
    static public func instantiateFromNib<T: Any>(owner: T) -> Self {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
                .instantiate(withOwner: owner, options: nil)
                .first! as! Self
    }
}

extension UIView: NibInstantiatable {}
