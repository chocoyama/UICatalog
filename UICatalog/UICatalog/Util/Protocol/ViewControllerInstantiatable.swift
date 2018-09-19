//
//  ViewControllerInstantiatable.swift
//  MiseryPot
//
//  Created by takyokoy on 2017/12/26.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

extension UIViewController: ViewControllerInstantiatable {}

public protocol ViewControllerInstantiatable {}
public extension ViewControllerInstantiatable where Self: UIViewController {
    public static func instantiate(storyboardName: String = "Main") -> Self {
        return UIStoryboard.instantiate(type: Self.self, storyboardName: storyboardName)
    }
}

private extension UIStoryboard {
    class func instantiate<T>(type: T.Type, storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

