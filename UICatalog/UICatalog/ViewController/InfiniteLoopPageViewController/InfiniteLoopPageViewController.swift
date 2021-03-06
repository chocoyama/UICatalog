//
//  InfiniteLoopPageViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol InfiniteLoopPageViewControllerDelegate: class {
    func infiniteLoopPageViewController(_ infiniteLoopPageViewController: InfiniteLoopPageViewController,
                                        didChangePageAt index: Int)
}

open class InfiniteLoopPageViewController: UIPageViewController {
    open weak var pageableDataSource: PageableViewControllerDataSource?
    open weak var loopPageDelegate: InfiniteLoopPageViewControllerDelegate?
    private(set) var pages: [Page]
    
    let shouldInfiniteLoop: Bool
    let pageCache = PageCache()
    
    public init(totalPage: Int,
                shouldInfiniteLoop: Bool,
                transitionStyle: UIPageViewController.TransitionStyle,
                navigationOrientation: UIPageViewController.NavigationOrientation,
                options: [UIPageViewController.OptionsKey : Any]?) {
        self.pages = (0..<totalPage).map { _ in Page() }
        self.pages.enumerated().forEach { $0.element.number = $0.offset }
        
        self.shouldInfiniteLoop = shouldInfiniteLoop
        
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
        dataSource = self
        delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setUp(at: 0, animated: false)
    }
    
    open func moveTo(page: Int, animated: Bool) {
        let currentPage = viewControllers?
            .compactMap { ($0 as? Pageable)?.pageNumber }
            .first ?? 0
        let direction: UIPageViewController.NavigationDirection = currentPage <= page ? .forward : .reverse
        setUp(at: page, direction: direction, animated: animated)
    }
    
    open func update(to pages: [Page], at page: Int = 0) {
        self.pages = pages
        setUp(at: page, animated: false)
    }
    
    open func setUp(at page: Int, direction: UIPageViewController.NavigationDirection = .forward, animated: Bool) {
        let index = pages.indices ~= page ? page : 0
        if let controller = getViewController(at: index) {
            setViewControllers([controller], direction: direction, animated: animated, completion: nil)
        }
    }
}

extension InfiniteLoopPageViewController {
    func getIndex(at viewController: UIViewController) -> Int? {
        guard let currentVC = viewController as? Pageable else { return nil }
        return pages.firstIndex { $0.number == currentVC.pageNumber }
    }
    
    func getViewController(at index: Int) -> UIViewController? {
        switch index {
        case -1 where shouldInfiniteLoop:
            if let lastIndex = pages.indices.last {
                return pageableDataSource?.viewController(at: lastIndex, for: self, cache: pageCache)
            } else {
                return nil
            }
        case -1:
            return nil
        case 0...(pages.count - 1):
            return pageableDataSource?.viewController(at: index, for: self, cache: pageCache)
        default:
            return shouldInfiniteLoop ? pageableDataSource?.viewController(at: 0, for: self, cache: pageCache) : nil
        }
    }
}

extension InfiniteLoopPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = getIndex(at: viewController) {
            return getViewController(at: pages.index(before: currentIndex))
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = getIndex(at: viewController) {
            return getViewController(at: pages.index(after: currentIndex))
        } else {
            return nil
        }
    }
}

extension InfiniteLoopPageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        guard let currentVC = viewControllers?.first,
            let currentIndex = getIndex(at: currentVC) else { return }
        loopPageDelegate?.infiniteLoopPageViewController(self, didChangePageAt: currentIndex)
    }
}
