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

    @IBOutlet weak var collectionView: UICollectionView!
    var layout = AdaptiveItemWidthLayout()
    
    private static let rowHeight: CGFloat = 50.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdaptiveItemWidthLayoutCollectionViewCell.register(for: collectionView)
        collectionView.dataSource = self
        layout.delegate = self
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
}

extension AdaptiveItemWidthLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return AdaptiveItemWidthLayoutCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(by: indexPath, backgroundColor: .random)
    }
}

extension AdaptiveItemWidthLayoutViewController: AdaptiveItemWidthLayoutable {
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return .random(min: 10, max: 80)
    }
}
