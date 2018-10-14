//
//  SamplePageSynchronizedContainerViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SamplePageSynchronizedContainerViewController: UIViewController {
    
    private let synchronizableCollectionVC: SamplePageSynchronizedCollectionViewController
    private let synchronizablePageVC: SynchronizablePageViewController
    private let containerVC: PageSynchronizedContainerViewController
    
    private let itemCount = 10
    
    init() {
        self.synchronizableCollectionVC = SamplePageSynchronizedCollectionViewController(
            numberOfItems: itemCount
        )
        self.synchronizablePageVC = SynchronizablePageViewController(
            with: (0..<itemCount).map { _ in NumberingViewController() },
            shouldInfiniteLoop: false,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        self.containerVC = PageSynchronizedContainerViewController(with: [
            synchronizableCollectionVC,
            synchronizablePageVC
        ])
        
        super.init(nibName: "SamplePageSynchronizedContainerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        synchronizableCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerVC.view.addSubview(synchronizableCollectionVC.view)
        NSLayoutConstraint.activate([
            synchronizableCollectionVC.view.topAnchor.constraint(equalTo: containerVC.view.topAnchor),
            synchronizableCollectionVC.view.leftAnchor.constraint(equalTo: containerVC.view.leftAnchor),
            synchronizableCollectionVC.view.rightAnchor.constraint(equalTo: containerVC.view.rightAnchor),
            synchronizableCollectionVC.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        synchronizablePageVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerVC.view.addSubview(synchronizablePageVC.view)
        NSLayoutConstraint.activate([
            synchronizablePageVC.view.topAnchor.constraint(equalTo: synchronizableCollectionVC.view.bottomAnchor),
            synchronizablePageVC.view.leftAnchor.constraint(equalTo: containerVC.view.leftAnchor),
            synchronizablePageVC.view.rightAnchor.constraint(equalTo: containerVC.view.rightAnchor),
            synchronizablePageVC.view.bottomAnchor.constraint(equalTo: containerVC.view.bottomAnchor),
        ])
    }

    @IBAction func didTappedButton(_ sender: UIButton) {
        navigationController?.pushViewController(containerVC, animated: true)
    }
}
