//
//  SampleTopTabViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

struct SamplePage: Page {
    typealias Entity = URL
    var number: Int
    var title: String
    var entity: Entity
}

class SampleTabMenuViewController: TabMenuViewController<SamplePage.Entity> {
    init(samplePages: [SamplePage]) {
        super.init(with: samplePages.map { SamplePageViewController(with: $0.typeErased()) })
        self.menuViewControllerDelegate = self
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
                               in collectionView: UICollectionView) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: IndexPath(item: page.number, section: 0))
            .configure(by: page.title, backgroundColor: .random)
    }
    
    func menuViewController<T>(_ menuViewController: MenuViewController<T>,
                               widthForItemAt page: AnyPage<T>) -> CGFloat {
        return 100
    }
    
    func heightForMenuView<T>(in menuViewController: MenuViewController<T>) -> CGFloat {
        return 50
    }
    
    func insetForMenuView<T>(in menuViewController: MenuViewController<T>) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
    }
}
