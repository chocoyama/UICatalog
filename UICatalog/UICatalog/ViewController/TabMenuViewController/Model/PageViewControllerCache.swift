//
//  PageViewControllerCache.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/11/10.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PageViewControllerCache {
    private var viewControllers: [PageViewController] = []
    
    func save(_ viewControllers: [PageViewController]) {
        self.viewControllers = viewControllers
    }
    
    open func get(from page: Page) -> PageViewController? {
        return viewControllers.first { $0.page.id == page.id }
    }
}

