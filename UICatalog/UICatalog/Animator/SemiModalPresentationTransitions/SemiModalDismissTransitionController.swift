//
//  SemiModalDismissTransitionController.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/08.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

class SemiModalDismissTransitionController: NSObject, UIViewControllerInteractiveTransitioning {
    var isInteractive: Bool = true
    weak var viewController: UIViewController?
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
    // swiftlint:disable:next function_body_length
    @objc func observePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let viewController = viewController else { return }
        guard let view = panGesture.view else { return }
        
        let translation = panGesture.translation(in: view)
        let velocity = panGesture.velocity(in: view)
        
        switch panGesture.state {
        case .possible:
            break
        case .began:
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            viewController.view.transform.ty = max(translation.y, 0)
        case .ended, .failed, .cancelled:
            if velocity.y > 0 && translation.y > 80 {
                let initialVelocity = abs(velocity.y)
                let distance = view.bounds.height - translation.y
                
                UIView.animate(withDuration: 0.45,
                               delay: 0,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: initialVelocity / distance,
                               options: .curveEaseInOut,
                               animations: {
                                view.alpha = 0
                                viewController.view.transform.ty = viewController.view.bounds.maxY
                },
                               completion: { _ in
                                self.transitionContext?.completeTransition(true)
                })
            } else {
                guard translation.y > 0 else {
                    self.transitionContext?.completeTransition(false)
                    return
                }
                
                let initialVelocity = velocity.y > 0 ? 0 : abs(velocity.y)
                let distance = translation.y
                
                UIView.animate(withDuration: 0.45,
                               delay: 0,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: initialVelocity / distance,
                               options: .curveEaseInOut,
                               animations: {
                                viewController.view.transform = .identity
                },
                               completion: { _ in
                                self.transitionContext?.completeTransition(false)
                })
            }
        @unknown default:
            break
        }
    }
}
