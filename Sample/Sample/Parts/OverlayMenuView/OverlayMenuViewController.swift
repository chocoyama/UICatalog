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
        
        var configuration = OverlayMenuView.Configuration()
        configuration.enablePresentingViewInteraction = true
        configuration.customView = NumberingViewController(pageNumber: 0).view
        overlayMenuView.setUp(with: configuration)
    }
    
}
