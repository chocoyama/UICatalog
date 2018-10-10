//
//  AdaptiveItemWidthLayoutViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class AdaptiveItemWidthLayoutViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            AdaptiveItemWidthLayoutCollectionViewCell.register(for: collectionView)
            AdaptiveItemCollectionReusableView.register(for: collectionView, ofKind: .sectionHeader)
            
            let layout = AdaptiveItemSizeLayout(adaptType: .width(.default))
            layout.delegate = self
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}

extension AdaptiveItemWidthLayoutViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1000
        case 1: return 1000
        case 2: return 1000
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return AdaptiveItemCollectionReusableView
                .dequeue(from: collectionView, ofKind: kind, for: indexPath)
                .configure(title: "section = \(indexPath.section)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return AdaptiveItemWidthLayoutCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(by: indexPath, backgroundColor: .random)
    }
}

extension AdaptiveItemWidthLayoutViewController: AdaptiveItemSizeLayoutDelegate {
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return .random(min: 10, max: 80)
    }
    
    func referenceSizeForHeader(in section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
