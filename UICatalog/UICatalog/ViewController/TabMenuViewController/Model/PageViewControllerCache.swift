//
//  PageViewControllerCache.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/11/10.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PageCache {
    private var viewControllers: [String: (UIViewController & Pageable)] = [:]
    
    public init() {}
    
    open func save(_ viewController: (UIViewController & Pageable), by id: String) {
        viewControllers[id] = viewController
    }
    
    open func get(from id: String) -> (UIViewController & Pageable)? {
        if viewControllers.keys.contains(id) {
            return viewControllers[id]
        } else {
            return nil
        }
    }
    
    open func clear() {
        viewControllers = [:]
    }
}

