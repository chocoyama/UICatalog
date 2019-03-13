//
//  OverlayMenuViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/11/06.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class OverlayMenuViewController: UIViewController {

    @IBOutlet weak var overlayMenuView: OverlayMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childViewController = AdaptiveItemHeightLayoutViewController
            .instantiate(storyboardName: "AdaptiveItemHeightLayoutViewController")
        childViewController.layout = AdaptiveItemSizeLayout(adaptType: .height(AdaptiveHeightConfiguration(
            columnCount: 5,
            minColumnCount: 1,
            maxColumnCount: Int.max,
            minimumInterItemSpacing: 5.0,
            minimumLineSpacing: 10.0,
            sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        )))
        addChild(childViewController)
        
        var configuration = OverlayMenuView.Configuration()
        configuration.enablePresentingViewInteraction = true
        configuration.customView = childViewController.view
        overlayMenuView.setUp(with: configuration)
        
        childViewController.didMove(toParent: self)
    }
    
}
