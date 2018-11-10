//
//  MenuViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ContentsPageViewController: SynchronizablePageViewController {
    private let configuration: TabMenuConfiguration
    
    public init(with controllers: [UIViewController & Pageable],
                configuration: TabMenuConfiguration,
                shouldInfiniteLoop: Bool,
                transitionStyle: UIPageViewController.TransitionStyle,
                navigationOrientation: UIPageViewController.NavigationOrientation,
                options: [UIPageViewController.OptionsKey : Any]?) {
        self.configuration = configuration
        super.init(with: controllers,
                   shouldInfiniteLoop: shouldInfiniteLoop,
                   transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = viewControllers?.first,
            let currentIndex = getIndex(at: currentVC) else { return }
        
        let adjustIndex = configuration.shouldShowMenuSettingItem ? currentIndex + 1 : currentIndex
        pagingSynchronizer?.pagingSynchronizer(changePageOnly: self, index: currentIndex, section: 0)
        pagingSynchronizer?.pagingSynchronizer(changePageExcept: self, index: adjustIndex, section: 0)
    }
}

open class TabMenuViewController<T>: PageSynchronizedContainerViewController {
    
    open weak var delegate: MenuViewControllerDelegate? {
        didSet {
            menuViewController.delegate = delegate
        }
    }
    
    public let cache = PageViewControllerCache<T>()
    
    private let configuration: TabMenuConfiguration
    private let menuViewController: MenuViewController<T>
    private let contentsPageViewController: ContentsPageViewController

    public init(with pageViewControllers: [PageViewController<T>],
                configuration: TabMenuConfiguration = TabMenuConfiguration()) {
        self.configuration = configuration
        
        let pages = pageViewControllers.map { $0.page }
        self.menuViewController = MenuViewController(with: pages, configuration: configuration)
        self.contentsPageViewController = ContentsPageViewController(
            with: pageViewControllers,
            configuration: configuration,
            shouldInfiniteLoop: false,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        cache.save(pageViewControllers)
        
        let children: [UIViewController & PagingChangeSubscriber] = [
            self.menuViewController,
            self.contentsPageViewController
        ]
        super.init(with: children)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        let inset = configuration.menuViewInset
        let height = configuration.menuViewHeight
        let menuViewHeight = inset.top + height + inset.bottom
        
        menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuViewController.view)
        NSLayoutConstraint.activate([
            menuViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuViewController.view.heightAnchor.constraint(equalToConstant: menuViewHeight)
        ])

        contentsPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentsPageViewController.view)
        NSLayoutConstraint.activate([
            contentsPageViewController.view.topAnchor.constraint(equalTo: menuViewController.view.bottomAnchor),
            contentsPageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentsPageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentsPageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    open func update(to pageViewControllers: [PageViewController<T>]) {
        let pages = pageViewControllers.map { $0.page }
        menuViewController.update(to: pages)
        contentsPageViewController.update(to: pageViewControllers)
        cache.save(pageViewControllers)
    }
}
