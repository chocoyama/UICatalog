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
    func menuViewController<T>(_ menuViewController: MenuViewController<T>,
                               didUpdated pages: [AnyPage<T>])
    func registerCellTo<T>(collectionView: UICollectionView, in menuViewController: MenuViewController<T>)
    func didSelectedAddIcon<T>(at: UICollectionView, in menuViewController: MenuViewController<T>)
}

open class MenuViewController<T>: SynchronizableCollectionViewController,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    enum Item {
        case setting
        case menu(page: AnyPage<T>)
        case add
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
        assignActions()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func update(to pages: [AnyPage<T>]) {
        self.items = MenuViewController<T>.constructItems(pages: pages,
                                                          configuration: configuration)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDelegate
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == settingIndex {
            showMenuSetting()
        } else if indexPath.item == addIndex {
            delegate?.didSelectedAddIcon(at: collectionView, in: self)
        } else {
            let adjustItem = configuration.shouldShowMenuSettingItem ? indexPath.item - 1 : indexPath.item
            pagingSynchronizer?.pagingSynchronizer(changePageOnly: self, index: indexPath.item, section: indexPath.section)
            pagingSynchronizer?.pagingSynchronizer(changePageExcept: self, index: adjustItem, section: indexPath.section)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.item] {
        case .setting:
            return MenuActionIconCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(iconConfiguration: configuration.settingIcon)
        case .menu(let page):
            if let cell = delegate?.menuViewController(self, cellForItemAt: page, in: collectionView, dequeueIndexPath: indexPath) {
                return cell
            } else {
                fatalError("Should implement MenuViewControllerDelegate.")
            }
        case .add:
            return MenuActionIconCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(iconConfiguration: configuration.addIcon)
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
        case .add:
            let diameter = configuration.menuViewHeight * CGFloat(configuration.addIcon.reductionRate)
            return CGSize(width: diameter, height: diameter)
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
    
    // MARK: User Action
    @objc private func viewDidLongPressed(_ sender: UILongPressGestureRecognizer) {
        switch configuration.longPressBehavior {
        case .presentMenu:
            showMenuSetting()
        case .none:
            break
        }
    }
}

extension MenuViewController: MenuSettingViewControllerDelegate {
    func menuSettingViewController<U>(_ menuSettingViewController: MenuSettingViewController<U>, didCommitPages pages: [AnyPage<U>]) {
        guard let pages = pages as? [AnyPage<T>] else { return }
        delegate?.menuViewController(self, didUpdated: pages)
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
        
        if configuration.shouldShowAddButton {
            items.append(.add)
        }
        
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
        MenuActionIconCollectionViewCell.register(for: collectionView, bundle: .current)
    }
    
    private func assignActions() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewDidLongPressed(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private var settingIndex: Int? {
        return items.firstIndex {
            switch $0 {
            case .setting: return true
            case .menu(_), .add: return false
            }
        }
    }
    
    private var addIndex: Int? {
        return items.firstIndex {
            switch $0 {
            case .add: return true
            case .setting, .menu(_): return false
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
