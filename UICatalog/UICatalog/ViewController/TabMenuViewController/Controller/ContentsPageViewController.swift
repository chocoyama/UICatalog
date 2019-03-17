//
//  ContentsPageViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/11/11.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class ContentsPageViewController: SynchronizablePageViewController {
    private let configuration: TabMenuConfiguration
    
    init(totalPage: Int,
         configuration: TabMenuConfiguration,
         shouldInfiniteLoop: Bool,
         transitionStyle: UIPageViewController.TransitionStyle,
         navigationOrientation: UIPageViewController.NavigationOrientation,
                options: [UIPageViewController.OptionsKey : Any]?) {
        self.configuration = configuration
        super.init(totalPage: totalPage,
                   shouldInfiniteLoop: shouldInfiniteLoop,
                   transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
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
