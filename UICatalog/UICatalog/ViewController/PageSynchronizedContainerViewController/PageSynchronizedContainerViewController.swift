//
//  PageSynchronizedViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PageSynchronizedContainerViewController: UIViewController, PagingSynchronizer {
    
    public init(with children: [UIViewController & PagingChangeSubscriber]) {
        super.init(nibName: nil, bundle: nil)
        for var childController in children {
            childController.pagingSynchronizer = self
            
            addChild(childController)
            childController.didMove(toParent: self)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
