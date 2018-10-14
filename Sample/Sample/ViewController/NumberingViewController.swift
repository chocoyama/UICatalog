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
    
    var page: Int = 0
    
    init() {
        super.init(nibName: "NumberingViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "\(page)"
    }
}
