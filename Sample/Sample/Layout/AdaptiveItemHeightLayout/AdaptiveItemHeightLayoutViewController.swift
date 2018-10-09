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

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }

    private func initLayout() {
        let layout = AdaptiveItemSizeLayout(adaptType: .height(.default))
        layout.delegate = self
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    @IBAction func didRecognizedPinchGesture(_ sender: UIPinchGestureRecognizer) {
        if case .ended = sender.state {
            if sender.scale > 1.0 {
                decrementColumn()
            } else if sender.scale < 1.0 {
                incrementColumn()
            }
        }
    }
}

extension AdaptiveItemHeightLayoutViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdaptiveSizeCollectionViewCell", for: indexPath) as! AdaptiveSizeCollectionViewCell
        return cell.configure(by: indexPath, backgroundColor: .random)
    }
}

extension AdaptiveItemHeightLayoutViewController: AdaptiveItemSizeLayoutDelegate, ColumnCountDynamicAsignable {
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return .random(min: 150.0, max: 300.0)
    }
}

