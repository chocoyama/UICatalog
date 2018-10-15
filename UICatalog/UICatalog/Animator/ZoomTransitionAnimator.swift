//
//  ZoomTransitionAnimator.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum AnimatorType {
        case present
        case dismiss
    }
    
    private var type: AnimatorType = .present
    
    override init() {
        super.init()
    }
    
    public init(type: AnimatorType) {
        super.init()
        self.type = type
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController
        let fromView: UIView
        let toVC: UIViewController
        let toView: UIView
        switch type {
        case .present:
            fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            fromView = fromVC.view
            toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            toView = toVC.view
        case .dismiss:
            fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
            fromView = fromVC.view
            toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            toView = toVC.view
        }
        
        switch type {
        case .present:
            guard
                let fromVCZoomTransitionAnimatorProtocol = fromVC as? ZoomTransitionFromAnimateProtocol,
                let transitionImageView = fromVCZoomTransitionAnimatorProtocol.transitionImageView() else {
                    return transitionContext.completeTransition(true)
            }
            let containerView = transitionContext.containerView
            let maskView = UIView(frame: containerView.frame)
            maskView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
            containerView.addSubview(maskView)
            
            let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
            transitionImageView.frame = convertedRect
            containerView.addSubview(transitionImageView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                switch UIApplication.shared.statusBarOrientation {
                case .portrait, .portraitUpsideDown:
                    transitionImageView.frame.size.height *= UIScreen.main.bounds.width / transitionImageView.frame.size.width
                    transitionImageView.frame.size.width = UIScreen.main.bounds.width
                    transitionImageView.frame.origin.x = 0.0
                    transitionImageView.frame.origin.y = (UIScreen.main.bounds.height + 20) / 2 - transitionImageView.frame.size.height / 2
                case .landscapeLeft, .landscapeRight:
                    transitionImageView.frame.size.width *= UIScreen.main.bounds.height / transitionImageView.frame.size.height
                    transitionImageView.frame.size.height = UIScreen.main.bounds.height
                    transitionImageView.frame.origin.x = UIScreen.main.bounds.width / 2 - transitionImageView.frame.size.width / 2
                    transitionImageView.frame.origin.y = 0.0
                case .unknown: break
                }
            }) { (finished) -> Void in
                maskView.removeFromSuperview()
                transitionImageView.removeFromSuperview()
                containerView.addSubview(toView)
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            guard
                let fromVCZoomTransitionAnimatorProtocol = fromVC as? ZoomTransitionToAnimateProtocol,
                let toVCZoomTransitionAnimatorProtocol = toVC as? ZoomTransitionFromAnimateProtocol,
                let transitionImageView = fromVCZoomTransitionAnimatorProtocol.transitionImageView else {
                    return transitionContext.completeTransition(true)
            }
            let containerView = transitionContext.containerView
            let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
            transitionImageView.frame = convertedRect
            containerView.addSubview(transitionImageView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                transitionImageView.frame = toVCZoomTransitionAnimatorProtocol.previousFrame()
            }, completion: { (finished) -> Void in
                transitionImageView.removeFromSuperview()
                containerView.addSubview(fromView)
                toVCZoomTransitionAnimatorProtocol.didEndZoomTransiton()
                transitionContext.completeTransition(true)
            })
        }
    }
}
