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
    
    public override init(with controllers: [UIViewController & Pageable],
                         shouldInfiniteLoop: Bool,
                         transitionStyle: UIPageViewController.TransitionStyle,
                         navigationOrientation: UIPageViewController.NavigationOrientation,
                         options: [UIPageViewController.OptionsKey : Any]?) {
        super.init(with: controllers,
                   shouldInfiniteLoop: shouldInfiniteLoop,
                   transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
        
        delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SynchronizablePageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        
        guard let currentVC = viewControllers?.first,
            let currentIndex = getIndex(at: currentVC) else { return }
        
        pagingSynchronizer?.pagingSynchronizer(didChangedPageAt: currentIndex, section: 0, observer: self)
    }
}

extension SynchronizablePageViewController: PagingChangeSubject {
    public func synchronize(pageIndex index: Int, section: Int, observer: PagingChangeObserver) {
        guard let currentVC = viewControllers?.first,
            let currentIndex = getIndex(at: currentVC) else { return }
        
        let controller = controllers[index]
        let direction: UIPageViewController.NavigationDirection = (index > currentIndex) ? .forward : .reverse
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
}
