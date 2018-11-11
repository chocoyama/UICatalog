//
//  SampleTopTabViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog
import WebKit

struct TopPage: Page {
    var id: String
    var title: String
    var pinned: Bool
    
    init(title: String) {
        self.id = title
        self.title = title
        self.pinned = true
    }
}

struct SamplePage: Page {
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

class SampleTabMenuViewController: TabMenuViewController {
    init(top: TopPage, pages: [SamplePage], configuration: TabMenuConfiguration) {
        var viewControllers: [PageViewController] = []
        viewControllers.append(SampleTopPageViewController(with: top))
        viewControllers.append(contentsOf: pages.map { SamplePageViewController(with: $0) })
        
        super.init(with: viewControllers, configuration: configuration)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleTabMenuViewController: MenuViewControllerDelegate {
    func registerCellTo(collectionView: UICollectionView, in menuViewController: MenuViewController) {
        LabelCollectionViewCell.register(for: collectionView)
    }
    
    func menuViewController(_ menuViewController: MenuViewController,
                            cellForItemAt page: Page,
                            in collectionView: UICollectionView,
                            dequeueIndexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: dequeueIndexPath)
            .configure(by: page.title, backgroundColor: .random)
    }
    
    func menuViewController(_ menuViewController: MenuViewController, widthForItemAt page: Page) -> CGFloat {
        return 100
    }
    
    func menuViewController(_ menuViewController: MenuViewController, didUpdated pages: [Page]) {
        let pageViewControllers = pages.map {
            self.cache.get(from: $0) ?? SamplePageViewController(with: $0)
        }
        update(to: pageViewControllers)
    }
    
    func didSelectedAddIcon(at: UICollectionView, in menuViewController: MenuViewController) {
        
    }
}

class SampleTopPageViewController: PageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = page.title
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
class SamplePageViewController: PageViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet { webView.load(URLRequest(url: (page as! SamplePage).url)) }
    }
}
