//
//  PageViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PageViewController<T>: UIViewController, Pageable {
    public let page: AnyPage<T>
    open var pageNumber: Int?
    
    public init(with page: AnyPage<T>) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
