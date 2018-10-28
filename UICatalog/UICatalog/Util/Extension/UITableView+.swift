//
//  UITableView+CustomExtension.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/04.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension UITableView {
    public func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: animated)
    }
    
    public func scrollToBottom(animated: Bool) {
        let contentOffset = CGPoint(
            x: 0.0,
            y: contentSize.height - frame.size.height + contentInset.bottom
        )
        setContentOffset(contentOffset, animated: animated)
    }
}

