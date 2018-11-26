//
//  SampleInfiniteLoopPageViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SampleInfiniteLoopPageViewController: UIViewController {
    
    let vc = InfiniteLoopPageViewController(
        pages: (0..<10).map { _ in Page() },
        shouldInfiniteLoop: true,
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    init() {
        super.init(nibName: "SampleInfiniteLoopPageViewController", bundle: nil)
        vc.pageableDataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTappedButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SampleInfiniteLoopPageViewController: PageableViewControllerDataSource {
    func viewController(at index: Int, cache: PageCache) -> (UIViewController & Pageable)? {
        return NumberingViewController(pageNumber: index)
    }
}
