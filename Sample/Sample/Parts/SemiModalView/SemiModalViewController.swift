//
//  OverlayMenuViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/11/06.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SemiModalViewController: UIViewController {

    @IBOutlet weak var semiModalView: SemiModalView!
    
    private let childViewController: UIViewController = {
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
        return childViewController
    }()
    
    private let position = SemiModalView.Position(
        initial: .init(coverRate: 0.0, maskViewAlpha: 0.2),
        compact: .init(coverRate: 0.1, maskViewAlpha: 0.2),
        middle: .init(coverRate: 0.3, maskViewAlpha: 0.2),
        overlay: .init(coverRate: 0.95, maskViewAlpha: 0.2),
        none: .init(coverRate: 0.0, maskViewAlpha: 0.0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childViewController)
        setUpOverlayMenuView()
        childViewController.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        semiModalView.updatePosition(to: position.middle)
    }
    
    private func setUpOverlayMenuView() {
        var configuration = SemiModalView.Configuration()
        configuration.enablePresentingViewInteraction = true
        configuration.customView = childViewController.view
        configuration.position = position
        semiModalView.setUp(with: configuration)
    }
    
}
