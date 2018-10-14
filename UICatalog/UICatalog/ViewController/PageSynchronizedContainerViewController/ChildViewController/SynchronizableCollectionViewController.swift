//
//  SynchronizableCollectionViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class SynchronizableCollectionViewController: UIViewController {

    public let collectionView: UICollectionView
    public let layout: UICollectionViewFlowLayout
    
    open weak var pagingSynchronizer: PagingSynchronizer?
    
    public init(layout: UICollectionViewFlowLayout) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.layout = layout
        
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension SynchronizableCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pagingSynchronizer?.pagingSynchronizer(subscriber: self, didChangedPageAt: indexPath.item, section: indexPath.section)
    }
}

extension SynchronizableCollectionViewController: PagingChangeSubscriber, PagingChangeObserver {
    public func synchronize(pageIndex index: Int, section: Int) {
        collectionView.indexPathsForSelectedItems?.forEach { collectionView.deselectItem(at: $0, animated: true) }
        let indexPath = IndexPath(item: index, section: section)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}
