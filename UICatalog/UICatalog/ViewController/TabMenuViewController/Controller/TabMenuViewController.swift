//
//  MenuViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class TabMenuViewController: PageSynchronizedContainerViewController {
    
    open weak var delegate: MenuViewControllerDelegate? {
        get { return menuViewController.delegate }
        set { menuViewController.delegate = newValue }
    }
    open var dataSource: PageableViewControllerDataSource? {
        get { return contentsPageViewController.pageableDataSource }
        set { contentsPageViewController.pageableDataSource = newValue }
    }
    
    private let configuration: TabMenuConfiguration
    private let menuViewController: MenuViewController
    private let contentsPageViewController: ContentsPageViewController

    public init(menus: [Menu],
                configuration: TabMenuConfiguration = TabMenuConfiguration()) {
        self.configuration = configuration
        self.menuViewController = MenuViewController(with: menus, configuration: configuration)
        self.contentsPageViewController = ContentsPageViewController(
            pages: menus.map { _ in Page() },
            configuration: configuration,
            shouldInfiniteLoop: false,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
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
    
    open func update(to menus: [Menu]) {
        let pages = menus.enumerated().map { Page(number: $0.offset) }
        
        menuViewController.update(to: menus)
        contentsPageViewController.update(to: pages)
    }
}
