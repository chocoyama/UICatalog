//
//  SamplePageViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/11/11.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation
import WebKit
import UICatalog

struct SampleMenu: Menu {
    var id: String
    var title: String
    var url: URL
    var pinned: Bool
    
    init(id: String? = nil, title: String, url: URL, pinned: Bool = false) {
        self.id = id ?? title
        self.title = title
        self.url = url
        self.pinned = pinned
    }
}

class SampleContentsPageViewController: UIViewController, Pageable {
    var pageNumber: Int
    
    private let sampleMenu: SampleMenu
    
    init(with sampleMenu: SampleMenu, pageNumber: Int) {
        self.sampleMenu = sampleMenu
        self.pageNumber = pageNumber
        super.init(nibName: "SampleContentsPageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var webView: WKWebView! {
        didSet { webView.load(URLRequest(url: sampleMenu.url)) }
    }
}
