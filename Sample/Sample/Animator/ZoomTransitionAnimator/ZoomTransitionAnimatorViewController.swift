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
    var selectedCollectionView: UICollectionView? { return collectionView }
    var latestTransitionIndexPath: IndexPath?
    var selectedImage: UIImage?
    var initialContentMode: UIView.ContentMode = .scaleAspectFill
    
    private let dataSource: [UIImage] = {
        let images = [
            UIImage(named: "sample")!,
            UIImage(named: "sample2")!,
            UIImage(named: "flower")!,
            UIImage(named: "load")!,
            UIImage(named: "cat")!,
            UIImage(named: "sky")!
        ]
        return images + images + images + images + images
    }()
    
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
                .configure(image: dataSource[indexPath.item], contentMode: initialContentMode)
    }
}

extension ZoomTransitionAnimatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = dataSource[indexPath.item]
        let selectedImage = image
        
        self.latestTransitionIndexPath = indexPath
        self.selectedImage = selectedImage
        
        let vc = ImageDetailViewController(initialElement: (image: selectedImage, index: indexPath.item),
                                           resources: dataSource.map { PhotoResource.image($0) },
                                           backgroundColor: .white)
        present(vc, animated: true, completion: nil)
    }
}

extension ZoomTransitionAnimatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(2) - CGFloat(8), height: 100)
    }
}
