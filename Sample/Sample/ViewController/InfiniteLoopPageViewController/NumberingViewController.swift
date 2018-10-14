//
//  NumberingViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class NumberingViewController: UIViewController, Pageable {
    
    @IBOutlet weak var label: UILabel!
    
    var page: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let page = page {
            self.label.text = "\(page)"
        } else {
            self.label.text = ""
        }
    }
}
