//
//  MenuViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol MenuViewControllerDelegate: class {
    func menuViewController<T>(_ menuViewController: MenuViewController<T>,
                               cellForItemAt page: AnyPage<T>,
                               in collectionView: UICollectionView,
                               dequeueIndexPath: IndexPath) -> UICollectionViewCell
    func menuViewController<T>(_ menuViewController: MenuViewController<T>,
                               widthForItemAt page: AnyPage<T>) -> CGFloat
    func registerCellTo<T>(collectionView: UICollectionView, in menuViewController: MenuViewController<T>)
}

open class MenuViewController<T>: SynchronizableCollectionViewController,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    enum Item {
        case setting
        case menu(page: AnyPage<T>)
    }
    
    open weak var delegate: MenuViewControllerDelegate?
    
    private let configuration: TabMenuConfiguration
    private var items: [MenuViewController<T>.Item] = []
    
    public init(with pages: [AnyPage<T>], configuration: TabMenuConfiguration) {
        self.configuration = configuration
        self.items = MenuViewController<T>.constructItems(pages: pages,
                                                          configuration: configuration)
        super.init(layout: MenuViewController<T>.constructLayout())
        configureCollectionView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDelegate
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let settingIndex = settingIndex else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
            return
        }
        
        switch indexPath.item {
        case let index where index < settingIndex:
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        case let index where index == settingIndex:
            showMenuSetting()
        case let index where index > settingIndex:
            let adjustedIndexPath = IndexPath(item: indexPath.item - 1,
                                              section: indexPath.section)
            super.collectionView(collectionView, didSelectItemAt: adjustedIndexPath)
        default: break
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.item] {
        case .setting:
            return MenuSettingCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(configuration: configuration.settingIcon)
        case .menu(let page):
            if let cell = delegate?.menuViewController(self, cellForItemAt: page, in: collectionView, dequeueIndexPath: indexPath) {
                return cell
            } else {
                fatalError("Should implement MenuViewControllerDelegate.")
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch items[indexPath.item] {
        case .setting:
            let diameter = configuration.menuViewHeight * CGFloat(configuration.settingIcon.reductionRate)
            return CGSize(width: diameter, height: diameter)
        case .menu(let page):
            if let width = delegate?.menuViewController(self, widthForItemAt: page) {
                return CGSize(width: width, height: configuration.menuViewHeight)
            } else {
                fatalError("Should implement MenuViewControllerDelegate.")
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return configuration.menuViewInset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.menuItemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.menuItemSpacing
    }
}

extension MenuViewController: MenuSettingViewControllerDelegate {
    func menuSettingViewController<U>(_ menuSettingViewController: MenuSettingViewController<U>, didCommitPages pages: [AnyPage<U>]) {
//        guard let pages = pages as? [AnyPage<T>] else { return }
//        self.items = MenuViewController<T>.constructItems(pages: pages,
//                                                          configuration: self.configuration)
//        collectionView.reloadData()
//        
//        TODO: Pageのデータソースの変更を伝え合うIFを作る必要あり
    }
}

extension MenuViewController {
    private class func constructItems(pages: [AnyPage<T>],
                                      configuration: TabMenuConfiguration) -> [MenuViewController<T>.Item] {
        var items = [Item]()
        if configuration.shouldShowMenuSettingItem {
            items.append(.setting)
        }
        items.append(contentsOf: pages.map { MenuViewController.Item.menu(page: $0) })
        return items
    }
    
    private class func constructLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceHorizontal = true
    }
    
    private func registerCells() {
        delegate?.registerCellTo(collectionView: collectionView, in: self)
        MenuSettingCollectionViewCell.register(for: collectionView, bundle: .current)
    }
    
    private var settingIndex: Int? {
        return items.firstIndex {
            switch $0 {
            case .setting: return true
            case .menu(_): return false
            }
        }
    }
    
    private func showMenuSetting() {
        let pages = self.items.compactMap { item -> AnyPage<T>? in
            guard case .menu(let page) = item else { return nil }
            return page
        }
        let vc = MenuSettingViewController(pages: pages)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
