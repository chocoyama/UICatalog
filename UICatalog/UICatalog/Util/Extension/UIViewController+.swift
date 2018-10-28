//
//  UIViewController+CustomExtension.swift
//  
//
//  Created by Takuya Yokoyama on 2018/10/05.
//

import UIKit

extension UIViewController {
    public func setNavigationTitleView(view: UIView) {
        let navigationBarFrame = self.navigationController?.navigationBar.frame ?? .zero
        view.frame = CGRect(x: 0, y: 0, width: navigationBarFrame.width, height: navigationBarFrame.height)
        self.navigationItem.titleView = view
    }
}
