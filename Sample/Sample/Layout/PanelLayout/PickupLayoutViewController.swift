//
//  PickupLayoutViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class PickupLayoutViewController: UIViewController {
    
    struct Item {
        let shouldPickup: Bool
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            LabelCollectionViewCell.register(for: collectionView)

            let layout = PickupLayout(columnCount: 3,
                                      lineCount: 2,
                                      largeItemMultipler: 2,
                                      itemHeight: 130)
//            let layout = PickupLayout(columnCount: 4,
//                                      lineCount: 2,
//                                      largeItemMultipler: 2,
//                                      itemHeight: 130)
            layout.delegate = self
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    private var items: [Item] = [
        .init(shouldPickup: true),.init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
    ]
    
}

extension PickupLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: indexPath)
            .configure(for: indexPath, backgroundColor: .random)
        if items[indexPath.item].shouldPickup {
            cell.label.text = "\(indexPath.item) (pickup)"
        } else {
            cell.label.text = "\(indexPath.item)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

extension PickupLayoutViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let maxIndexPath = collectionView.indexPathsForVisibleItems.max(by: { (indexPath1, indexPath2) -> Bool in
            indexPath1.item < indexPath2.item
        }) else {
            return
        }
        
        let threshold = 10
        let fetchPosition = (items.count - 1) - threshold
        let shouldPrefetch = maxIndexPath.item >= fetchPosition
        if shouldPrefetch {
            let items: [Item] = [
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: true),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: true),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
                .init(shouldPickup: false),.init(shouldPickup: false),.init(shouldPickup: false),
            ]
            let indexPaths = (self.items.count..<self.items.count+items.count).map { IndexPath(item: $0, section: 0) }
            self.items.append(contentsOf: items)
            collectionView.insertItems(at: indexPaths)
        }
    }
}

extension PickupLayoutViewController: PickupLayoutDelegate {
    func indexPathsForPickupItem(_ pickupLayout: PickupLayout) -> [IndexPath]? {
        return items
            .enumerated()
            .filter { $0.element.shouldPickup }
            .map { IndexPath(item: $0.offset, section: 0) }
    }
    
    func pickupLayout(_ pickupLayout: PickupLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func pickupLayout(_ pickupLayout: PickupLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func pickupLayout(_ pickupLayout: PickupLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
}
