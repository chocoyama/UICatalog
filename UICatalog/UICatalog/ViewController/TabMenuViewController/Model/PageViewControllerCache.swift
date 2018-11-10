//
//  PageViewControllerCache.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/11/10.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PageViewControllerCache<T> {
    private var viewControllers: [PageViewController<T>] = []
    
    func save(_ viewControllers: [PageViewController<T>]) {
        self.viewControllers = viewControllers
    }
    
    open func get(from page: AnyPage<T>) -> PageViewController<T>? {
        return viewControllers.first { $0.page == page }
    }
}

