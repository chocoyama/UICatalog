//
//  OverlayMenuViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/11/06.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SemiModalRelativeViewController: UIViewController {

    @IBOutlet weak var semiModalView: SemiModalView! {
        didSet {
            semiModalView.delegate = self
        }
    }
    
    private let childViewController = createChildViewController()
    
    private let relativePosition = SemiModalView.RelativePosition(
        compact: .init(coverRate: 0.2, maskViewAlpha: 0.2),
        middle: .init(coverRate: 0.4, maskViewAlpha: 0.2),
        overlay: .init(coverRate: 0.95, maskViewAlpha: 0.2)
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childViewController)
        setupRelativeOverlayMenuView()
        childViewController.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        semiModalView.show(from: relativePosition.none, to: relativePosition.middle)
    }
    
    private func setupRelativeOverlayMenuView() {
        var config = SemiModalView.Configuration()
        config.customView = childViewController.view
        config.position = .relative(relativePosition)
        config.enablePresentingViewInteraction = true
        config.enableAutoRelocation = true
        semiModalView.setUp(with: config)
    }
    
    @IBAction func didTappedShowButton(_ sender: UIButton) {
        semiModalView.updatePosition(to: relativePosition.compact, animated: true)
    }
}

extension SemiModalRelativeViewController: SemiModalViewDelegate {
    func semiModalView(_ semiModalView: SemiModalView, didTappedNonModalArea point: CGPoint) {
        semiModalView.updatePosition(to: relativePosition.none, animated: true)
    }
}

class SemiModalAbsoluteViewController: UIViewController {
    @IBOutlet weak var semiModalView: SemiModalView! {
        didSet {
//            semiModalView.delegate = self
        }
    }
    
    private let childViewController = createChildViewController()
    
    private let absolutePosition = SemiModalView.AbsolutePosition(
        max: .init(height: 300.0, maskViewAlpha: 0.2),
        min: .init(height: 0.0, maskViewAlpha: 0.0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childViewController)
        setupAbsoluteOverlayMenuView()
        childViewController.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        semiModalView.show(from: absolutePosition.none, to: absolutePosition.max)
    }
    
    private func setupAbsoluteOverlayMenuView() {
        var config = SemiModalView.Configuration()
        config.customView = childViewController.view
        config.position = .absolute(absolutePosition)
        config.enablePresentingViewInteraction = false
        config.enableAutoRelocation = true
        semiModalView.setUp(with: config)
    }
    
    @IBAction func didTappedShowButton(_ sender: UIButton) {
        semiModalView.updatePosition(to: absolutePosition.max, animated: true)
    }
}

//extension SemiModalAbsoluteViewController: SemiModalViewDelegate {
//    func semiModalView(_ semiModalView: SemiModalView, didTappedNonModalArea point: CGPoint) {
//        semiModalView.updatePosition(to: absolutePosition.min, animated: true)
//    }
//}

private func createChildViewController() -> UIViewController  {
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
}

