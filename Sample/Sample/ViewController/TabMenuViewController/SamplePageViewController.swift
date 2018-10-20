//
//  SamplePageViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SamplePageViewController: PageViewController<SamplePage.Entity> {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = page.title
    }
    
}
