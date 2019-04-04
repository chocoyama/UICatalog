//
//  PickupLayoutViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2019/04/03.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class PanelLayoutViewController: UIViewController {
    
    struct Item {
        let shouldPickup: Bool
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            LabelCollectionViewCell.register(for: collectionView)
     
            let layout = PanelLayout(itemHeight: 150,
                                     collectionViewWidth: collectionView.frame.width)
            layout.delegate = self
            collectionView.dataSource = self
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    private let items: [Item] = [
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
        .init(shouldPickup: true),.init(shouldPickup: true),
        .init(shouldPickup: false),.init(shouldPickup: false),
    ]
    
}

extension PanelLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: indexPath)
            .configure(for: indexPath, backgroundColor: .random)
        if items[indexPath.item].shouldPickup {
            cell.label.text = "ピックアップしたいやつ"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

extension PanelLayoutViewController: PanelLayoutDelegate {
    func panelLayout(_ panelLayout: PanelLayout, shouldPickUpItemAt indexPath: IndexPath) -> Bool {
        return items[indexPath.item].shouldPickup
    }
}
