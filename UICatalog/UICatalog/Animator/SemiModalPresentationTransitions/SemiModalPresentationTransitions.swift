//
//  SemiModalPresentationTransitions.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/07.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public final class SemiModalPresentationTransitions: NSObject {
    public enum Animation {
        case system
        case custom
    }
    private let dismissTransitionController: SemiModalDismissTransitionController
    private let animation: Animation
    
    public init(viewController: UIViewController, animation: Animation) {
        dismissTransitionController = SemiModalDismissTransitionController(viewController: viewController)
        self.animation = animation
    }
}

extension SemiModalPresentationTransitions: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented,
                                      presenting: presenting,
                                      dismissTransitionController: dismissTransitionController)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch animation {
        case .system:
            return nil
        case .custom where dismissTransitionController.isInteractive:
            return dismissTransitionController
        case .custom:
            return nil
        }
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch animation {
        case .system:
            return nil
        case .custom:
            return AnimationController(isPresenting: true)
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch animation {
        case .system:
            return nil
        case .custom where dismissTransitionController.isInteractive:
            return NoAnimatedAnimationController()
        case .custom:
            return AnimationController(isPresenting: false)
        }
    }
}
