//
//  InfiniteLoopPageViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class InfiniteLoopPageViewController: UIPageViewController {

    private(set) var controllers: [UIViewController & Pageable]
    let shouldInfiniteLoop: Bool
    
    public init(with controllers: [UIViewController & Pageable],
                shouldInfiniteLoop: Bool,
                transitionStyle: UIPageViewController.TransitionStyle,
                navigationOrientation: UIPageViewController.NavigationOrientation,
                options: [UIPageViewController.OptionsKey : Any]?) {
        
        self.controllers = controllers
        controllers.enumerated().forEach { $0.element.pageNumber = $0.offset }
        
        self.shouldInfiniteLoop = shouldInfiniteLoop
        
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
        dataSource = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setUp(at: 0)
    }
    
    open func update(to controllers: [UIViewController & Pageable], at page: Int = 0) {
        self.controllers = controllers
        controllers.enumerated().forEach { $0.element.pageNumber = $0.offset }
        setUp(at: page)
    }
    
    private func setUp(at page: Int) {
        let index = controllers.indices ~= page ? page : 0
        let controller = controllers[index]
        setViewControllers([controller], direction: .forward, animated: false, completion: nil)
    }
}

extension InfiniteLoopPageViewController {
    func getIndex(at viewController: UIViewController) -> Int? {
        guard let currentVC = viewController as? Pageable else { return nil }
        return controllers.index { $0.pageNumber == currentVC.pageNumber }
    }
    
    func getViewController(at index: Int) -> UIViewController? {
        switch index {
        case -1 where shouldInfiniteLoop:
            return controllers.last
        case -1:
            return nil
        case 0...(controllers.count - 1):
            return controllers[index]
        default:
            return shouldInfiniteLoop ? controllers.first : nil
        }
    }
}

extension InfiniteLoopPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = getIndex(at: viewController) {
            return getViewController(at: controllers.index(before: currentIndex))
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = getIndex(at: viewController) {
            return getViewController(at: controllers.index(after: currentIndex))
        } else {
            return nil
        }
    }
}
