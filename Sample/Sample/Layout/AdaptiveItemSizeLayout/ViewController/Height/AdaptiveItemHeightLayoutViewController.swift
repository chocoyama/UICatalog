//
//  ViewController.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/30.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class AdaptiveItemHeightLayoutViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            AdaptiveItemCollectionViewCell.register(for: collectionView)
            AdaptiveItemCollectionReusableView.register(for: collectionView, ofKind: .sectionHeader)
            
            let layout = AdaptiveItemSizeLayout(adaptType: .height(.default))
            layout.delegate = self
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    @IBAction func didRecognizedPinchGesture(_ sender: UIPinchGestureRecognizer) {
        guard case .ended = sender.state else { return }
        if sender.scale > 1.0 {
            decrementColumn()
        } else if sender.scale < 1.0 {
            incrementColumn()
        }
    }
}

extension AdaptiveItemHeightLayoutViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 100
        case 1: return 100
        case 2: return 100
        case 3: return 100
        case 4: return 100
        default: fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return AdaptiveItemCollectionReusableView
                .dequeue(from: collectionView, ofKind: kind, for: indexPath)
                .configure(title: "section = \(indexPath.section)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return AdaptiveItemCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(by: indexPath, backgroundColor: .random)
    }
}

extension AdaptiveItemHeightLayoutViewController: AdaptiveItemSizeLayoutDelegate, ColumnCountDynamicAsignable {
    func adaptiveItemSizeLayout(_ layout: AdaptiveItemSizeLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .random(min: 150.0, max: 300.0)
    }
    
    func adaptiveItemSizeLayout(_ layout: AdaptiveItemSizeLayout, referenceSizeForHeaderIn section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

