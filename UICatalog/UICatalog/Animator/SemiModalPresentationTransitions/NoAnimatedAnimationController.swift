//
//  NoAnimatedAnimationController.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/08.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

class NoAnimatedAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0 }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}
