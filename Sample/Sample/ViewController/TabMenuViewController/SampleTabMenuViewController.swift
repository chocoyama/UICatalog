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
    private let cache = PageCache()
    
    init(topMenu: TopMenu, sampleMenus: [SampleMenu], configuration: TabMenuConfiguration) {
        self.menus = [topMenu] + sampleMenus
        super.init(menus: menus, configuration: configuration)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleTabMenuViewController: MenuViewControllerDelegate {
    func registerCellTo(collectionView: UICollectionView, in menuViewController: MenuViewController) {
        LabelCollectionViewCell.register(for: collectionView)
    }
    
    func menuViewController(_ menuViewController: MenuViewController,
                            cellForItemAt menu: Menu,
                            in collectionView: UICollectionView,
                            dequeueIndexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: dequeueIndexPath)
            .configure(by: menu.title, backgroundColor: .random)
    }
    
    func menuViewController(_ menuViewController: MenuViewController, widthForItemAt menu: Menu) -> CGFloat {
        return 100
    }
    
    func menuViewController(_ menuViewController: MenuViewController, didUpdated menus: [Menu]) {
        self.menus = menus
        update(to: menus)
    }
    
    func didSelectedAddIcon(at: UICollectionView, in menuViewController: MenuViewController) {
        
    }
}

extension SampleTabMenuViewController: PageableViewControllerDataSource {
    func viewController(at index: Int) -> (UIViewController & Pageable)? {
        let menu = menus[index]
        if let cachedVC = cache.get(from: menu.id) {
            return cachedVC
        }
        
        switch menu {
        case let topMenu as TopMenu:
            let vc = SampleTopPageViewController(with: topMenu, pageNumber: index)
            cache.save(vc, with: menu.id)
            return vc
        case let sampleMenu as SampleMenu:
            let vc = SamplePageViewController(with: sampleMenu, pageNumber: index)
            cache.save(vc, with: menu.id)
            return vc
        default:
            return nil
        }
    }
}
