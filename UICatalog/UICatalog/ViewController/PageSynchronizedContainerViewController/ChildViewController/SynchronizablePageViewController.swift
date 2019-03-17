//
//  SynchronizablePageViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class SynchronizablePageViewController: InfiniteLoopPageViewController {
    
    open weak var pagingSynchronizer: PagingSynchronizer?
    
    public override init(totalPage: Int,
                         shouldInfiniteLoop: Bool,
                         transitionStyle: UIPageViewController.TransitionStyle,
                         navigationOrientation: UIPageViewController.NavigationOrientation,
                         options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(totalPage: totalPage,
                   shouldInfiniteLoop: shouldInfiniteLoop,
                   transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
        
        loopPageDelegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SynchronizablePageViewController: InfiniteLoopPageViewControllerDelegate {
    public func infiniteLoopPageViewController(_ infiniteLoopPageViewController: InfiniteLoopPageViewController, didChangePageAt index: Int) {
        pagingSynchronizer?.pagingSynchronizer(didChangedPageAt: index, section: 0, observer: self)
    }
}

extension SynchronizablePageViewController: PagingChangeSubject {
    public func synchronize(pageIndex index: Int, section: Int, observer: PagingChangeObserver) {
        guard let currentVC = viewControllers?.first,
            let currentIndex = getIndex(at: currentVC) else { return }
        
        let direction: UIPageViewController.NavigationDirection = (index > currentIndex) ? .forward : .reverse
        setUp(at: index, direction: direction, animated: false)
    }
}
