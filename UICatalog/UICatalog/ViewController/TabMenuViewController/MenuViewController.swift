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
    
    private let configuration: TabMenuViewController<T>.Configuration
    private let pages: [AnyPage<T>]
    open weak var delegate: MenuViewControllerDelegate?
    
    public init(with pages: [AnyPage<T>], configuration: TabMenuViewController<T>.Configuration) {
        self.pages = pages
        self.configuration = configuration
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(layout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceHorizontal = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.registerCellTo(collectionView: collectionView, in: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = delegate?.menuViewController(self,
                                                cellForItemAt: pages[indexPath.item],
                                                in: collectionView,
                                                dequeueIndexPath: indexPath)
        if let cell = cell {
            return cell
        } else {
            fatalError("Should implement MenuViewControllerDelegate.")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let width = delegate?.menuViewController(self, widthForItemAt: pages[indexPath.item]) else {
            fatalError("Should implement MenuViewControllerDelegate.")
        }
        return CGSize(width: width, height: configuration.menuViewHeight)
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
