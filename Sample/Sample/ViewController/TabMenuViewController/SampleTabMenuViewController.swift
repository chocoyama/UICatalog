//
//  SampleTopTabViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SampleTabMenuViewController: TabMenuViewController {
    private var menus: [Menu]
    
    init(topMenu: TopMenu, sampleMenus: [SampleMenu], configuration: TabMenuConfiguration) {
        menus = [topMenu] + sampleMenus
        super.init(menus: menus, configuration: configuration)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleTabMenuViewController: MenuViewControllerDelegate {
    func registerCellTo(collectionView: UICollectionView, in menuViewController: MenuViewController) {
        LabelCollectionViewCell.register(for: collectionView)
    }
    
    func menuViewController(_ menuViewController: MenuViewController, cellForItemAt menu: Menu, in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: indexPath)
            .configure(for: menu.title, backgroundColor: .random)
    }
    
    func menuViewController(_ menuViewController: MenuViewController, widthForItemAt menu: Menu) -> CGFloat {
        return 100
    }
    
    func menuViewController(_ menuViewController: MenuViewController, didUpdated menus: [Menu]) {
        self.menus = menus
        update(to: menus)
    }
}

extension SampleTabMenuViewController: PageableViewControllerDataSource {
    func viewController(at index: Int, cache: PageCache) -> (UIViewController & Pageable)? {
        let menu = menus[index]
        
        if let cachedVC = cache.get(from: menu.id) { return cachedVC }
        
        let vc: (UIViewController & Pageable)
        switch menu {
        case let menu as TopMenu: vc = SampleTopPageViewController(with: menu, pageNumber: index)
        case let menu as SampleMenu: vc = SampleContentsPageViewController(with: menu, pageNumber: index)
        default: return nil
        }
        
        cache.save(vc, with: menu.id)
        return vc
    }
}

