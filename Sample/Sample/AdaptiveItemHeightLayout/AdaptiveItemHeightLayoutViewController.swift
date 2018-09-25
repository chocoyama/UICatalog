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

    // MARK:- AdaptiveItemHeightLayoutable
    @IBOutlet weak var collectionView: UICollectionView!
    var layout = AdaptiveItemHeightLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }

    private func initLayout() {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdaptiveSizeCollectionViewCell", for: indexPath) as! AdaptiveSizeCollectionViewCell
        return cell.configure(by: indexPath, backgroundColor: .random)
    }
}

extension AdaptiveItemHeightLayoutViewController: AdaptiveItemHeightLayoutable {
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return .random(min: 150.0, max: 300.0)
    }
}
