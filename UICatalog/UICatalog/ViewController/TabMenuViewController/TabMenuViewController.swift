//
//  MenuViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class TabMenuViewController<T>: PageSynchronizedContainerViewController {
    
    open weak var menuViewControllerDelegate: MenuViewControllerDelegate? {
        didSet {
            menuViewController.delegate = menuViewControllerDelegate
        }
    }
    
    private let configuration: Configuration
    private let menuViewController: MenuViewController<T>
    private let synchronizablePageViewController: SynchronizablePageViewController

    public init(with pageViewControllers: [PageViewController<T>], configuration: Configuration = Configuration()) {
        self.configuration = configuration
        
        let pages = pageViewControllers.map { $0.page }
        self.menuViewController = MenuViewController(with: pages, configuration: configuration)
        self.synchronizablePageViewController = SynchronizablePageViewController(
            with: pageViewControllers,
            shouldInfiniteLoop: false,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        let children: [UIViewController & PagingChangeSubscriber] = [
            self.menuViewController,
            self.synchronizablePageViewController
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

        synchronizablePageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(synchronizablePageViewController.view)
        NSLayoutConstraint.activate([
            synchronizablePageViewController.view.topAnchor.constraint(equalTo: menuViewController.view.bottomAnchor),
            synchronizablePageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            synchronizablePageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            synchronizablePageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
