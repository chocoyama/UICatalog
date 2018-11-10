//
//  SampleTopTabViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog
import WebKit

struct SamplePage: Page {
    typealias Entity = URL
    var id: String
    var title: String
    var entity: Entity
    
    init(id: String? = nil, title: String, entity: Entity) {
        self.id = id ?? title
        self.title = title
        self.entity = entity
    }
}

class SampleTabMenuViewController: TabMenuViewController<SamplePage.Entity> {
    init(pages: [SamplePage]) {
        let pageViewControllers = pages.map { SamplePageViewController(with: $0.typeErased()) }
        
        var configuration = TabMenuConfiguration()
        configuration.shouldShowMenuSettingItem = true
        configuration.settingIcon.reductionRate = 0.8
        configuration.shouldShowAddButton = true
        configuration.addIcon.reductionRate = 0.8
        configuration.longPressBehavior = .presentMenu
        
        super.init(with: pageViewControllers, configuration: configuration)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleTabMenuViewController: MenuViewControllerDelegate {
    func registerCellTo<T>(collectionView: UICollectionView, in menuViewController: MenuViewController<T>) {
        LabelCollectionViewCell.register(for: collectionView)
    }
    
    func menuViewController<T>(_ menuViewController: MenuViewController<T>,
                               cellForItemAt page: AnyPage<T>,
                               in collectionView: UICollectionView,
                               dequeueIndexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: dequeueIndexPath)
            .configure(by: page.title, backgroundColor: .random)
    }
    
    func menuViewController<T>(_ menuViewController: MenuViewController<T>, widthForItemAt page: AnyPage<T>) -> CGFloat {
        return 100
    }
    
    func menuViewController<T>(_ menuViewController: MenuViewController<T>, didUpdated pages: [AnyPage<T>]) {
        // TODO: キャストしなくてもなんとかならないか
        guard let pages = pages as? [AnyPage<SamplePage.Entity>] else { return }
        let pageViewControllers = pages.map {
            self.cache.get(from: $0) ?? SamplePageViewController(with: $0)
        }
        update(to: pageViewControllers)
    }
    
    func didSelectedAddIcon<T>(at: UICollectionView, in menuViewController: MenuViewController<T>) {
        
    }
}

class SamplePageViewController: PageViewController<SamplePage.Entity> {
    @IBOutlet weak var webView: WKWebView! {
        didSet { webView.load(URLRequest(url: page.entity)) }
    }
}
