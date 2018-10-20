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
                               in collectionView: UICollectionView,
                               dequeueIndexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: dequeueIndexPath)
            .configure(by: page.title, backgroundColor: .random)
    }
    
    func menuViewController<T>(_ menuViewController: MenuViewController<T>, widthForItemAt page: AnyPage<T>) -> CGFloat {
        return 100
    }
}
