//
//  ZoomTransitionAnimatorViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class ZoomTransitionAnimatorViewController: UIViewController, ZoomTransitionFromAnimateProtocol {

    var latestTransitionIndexPath: IndexPath?
    var selectedImage: UIImage?
    
    private let dataSource: [UIImage] = (0..<100).map { _ in UIImage(named: "cat")! }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            ImageCollectionViewCell.register(for: collectionView)
        }
    }
    
}

extension ZoomTransitionAnimatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImageCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .configure(image: dataSource[indexPath.item])
    }
}

extension ZoomTransitionAnimatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = dataSource[indexPath.item]
        
        self.latestTransitionIndexPath = indexPath
        self.selectedImage = image
        
        let resources: [PhotoResource] = [
            .image(image), .image(UIImage(named: "flower")!), .image(UIImage(named: "sky")!)
        ]
        let vc = ImageDetailViewController(resources: resources + resources + resources, backgroundColor: .black)
        present(vc, animated: true, completion: nil)
    }
}

extension ZoomTransitionAnimatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(2) - CGFloat(8), height: 200)
    }
}
