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
            
            let layout = AdaptiveItemSizeLayout(adaptType: .width(.default))
            layout.delegate = self
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
}

extension AdaptiveItemWidthLayoutViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 10
        case 1: return 1000
        default: return 0
        }
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
}
