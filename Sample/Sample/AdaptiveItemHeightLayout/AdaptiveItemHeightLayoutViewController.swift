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
    
    private var randomColor: UIColor {
        let r = (CGFloat(arc4random_uniform(255)) + 1) / 255
        let g = (CGFloat(arc4random_uniform(255)) + 1) / 255
        let b = (CGFloat(arc4random_uniform(255)) + 1) / 255
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    private var randomSize: CGSize {
        let min: CGFloat = 150.0
        let max: CGFloat = 300.0
        let diff = UInt32(max - min)
        
        let width = CGFloat(arc4random_uniform(diff)) + min
        let height = CGFloat(arc4random_uniform(diff)) + min
        return CGSize(width: width, height: height)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdaptiveSizeCollectionViewCell", for: indexPath)
        cell.backgroundColor = randomColor
        return cell
    }
}

extension AdaptiveItemHeightLayoutViewController: AdaptiveItemHeightLayoutable {
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return randomSize
    }
}
