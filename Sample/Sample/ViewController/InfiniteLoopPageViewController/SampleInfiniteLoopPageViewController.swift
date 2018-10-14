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
        with: (0..<10).map { _ in NumberingViewController() },
        shouldInfiniteLoop: true,
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    @IBAction func didTappedButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
