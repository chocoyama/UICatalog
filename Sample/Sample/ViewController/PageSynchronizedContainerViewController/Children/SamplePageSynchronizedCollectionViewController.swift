//
//  SamplePageSynchronizedCollectionViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SamplePageSynchronizedCollectionViewController: SynchronizableCollectionViewController {
    
    private let numberOfItems: Int
    
    init(numberOfItems: Int) {
        self.numberOfItems = numberOfItems
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(layout: layout)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelCollectionViewCell.register(for: collectionView)
    }
}

extension SamplePageSynchronizedCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: indexPath)
            .configure(by: indexPath, backgroundColor: .random)
    }
}

extension SamplePageSynchronizedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 100
        let height = collectionView.bounds.height * 0.8
        return CGSize(width: width, height: height)
    }
}
