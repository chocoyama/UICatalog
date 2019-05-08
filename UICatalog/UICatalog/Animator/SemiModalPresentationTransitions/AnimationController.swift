//
//  AnimationController.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/08.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension SemiModalPresentationTransitions {
    final class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
        let isPresenting: Bool
        
        init(isPresenting: Bool) {
            self.isPresenting = isPresenting
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.25
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            if isPresenting {
                animateForPresentation(context: transitionContext)
            } else {
                animateForDismissal(context: transitionContext)
            }
        }
        
        func animateForPresentation(context: UIViewControllerContextTransitioning) {
            guard let destination = context.viewController(forKey: .to) else { return }
            
            let containerView = context.containerView
            destination.view.transform.ty = containerView.bounds.height
            containerView.addSubview(destination.view)
            let animator = UIViewPropertyAnimator(duration: transitionDuration(using: context), dampingRatio: 1) {
                destination.view.transform = .identity
            }
            animator.addCompletion { (position) in
                context.completeTransition(position == .end)
            }
            animator.startAnimation()
        }
        
        func animateForDismissal(context: UIViewControllerContextTransitioning) {
            guard let from = context.viewController(forKey: .from) else { return }
            let containerView = context.containerView
            
            UIView.animate(withDuration: transitionDuration(using: context),
                           animations: {
                            from.view.transform.ty = containerView.bounds.height + from.view.bounds.height
            },
                           completion: { _ in
                            context.completeTransition(true)
            })
        }
    }
}
