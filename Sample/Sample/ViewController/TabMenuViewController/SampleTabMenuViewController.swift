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

class SampleTabMenuViewController: TabMenuViewController {
    private var menus: [Menu]
    private let cache = PageCache()
    
    init(topMenu: TopMenu, sampleMenus: [SampleMenu], configuration: TabMenuConfiguration) {
        self.menus = [topMenu] + sampleMenus
        super.init(menus: menus, configuration: configuration)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleTabMenuViewController: PageableViewControllerDataSource {
    func viewController(at index: Int) -> (UIViewController & Pageable)? {
        let menu = menus[index]
        if let cachedVC = cache.get(from: menu.id) {
            return cachedVC
        }
        
        switch menu {
        case let topMenu as TopMenu:
            let vc = SampleTopPageViewController(with: topMenu, pageNumber: index)
            cache.save(vc, by: menu.id)
            return vc
        case let sampleMenu as SampleMenu:
            let vc = SamplePageViewController(with: sampleMenu, pageNumber: index)
            cache.save(vc, by: menu.id)
            return vc
        default:
            return nil
        }
    }
}

extension SampleTabMenuViewController: MenuViewControllerDelegate {
    func registerCellTo(collectionView: UICollectionView, in menuViewController: MenuViewController) {
        LabelCollectionViewCell.register(for: collectionView)
    }
    
    func menuViewController(_ menuViewController: MenuViewController,
                            cellForItemAt menu: Menu,
                            in collectionView: UICollectionView,
                            dequeueIndexPath: IndexPath) -> UICollectionViewCell {
        return LabelCollectionViewCell
            .dequeue(from: collectionView, indexPath: dequeueIndexPath)
            .configure(by: menu.title, backgroundColor: .random)
    }
    
    func menuViewController(_ menuViewController: MenuViewController, widthForItemAt menu: Menu) -> CGFloat {
        return 100
    }
    
    func menuViewController(_ menuViewController: MenuViewController, didUpdated menus: [Menu]) {
        self.menus = menus
        update(to: menus)
    }
    
    func didSelectedAddIcon(at: UICollectionView, in menuViewController: MenuViewController) {
        
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

class SamplePageViewController: UIViewController, Pageable {
    var pageNumber: Int
    
    private let sampleMenu: SampleMenu
    
    init(with sampleMenu: SampleMenu, pageNumber: Int) {
        self.sampleMenu = sampleMenu
        self.pageNumber = pageNumber
        super.init(nibName: "SamplePageViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var webView: WKWebView! {
        didSet { webView.load(URLRequest(url: sampleMenu.url)) }
    }
}
