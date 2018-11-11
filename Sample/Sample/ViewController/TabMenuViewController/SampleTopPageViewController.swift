//
//  SampleTopPageViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/11/11.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation
import UICatalog

struct TopMenu: Menu {
    var id: String
    var title: String
    var pinned: Bool
    
    init(title: String) {
        self.id = title
        self.title = title
        self.pinned = true
    }
}

class SampleTopPageViewController: UIViewController, Pageable {
    var pageNumber: Int
    
    private let topMenu: TopMenu
    
    init(with topMenu: TopMenu, pageNumber: Int) {
        self.topMenu = topMenu
        self.pageNumber = pageNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "トップ"
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}
