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
        let fromVC = getViewController(using: transitionContext, key: .from)!
        let toVC = getViewController(using: transitionContext, key: .to)!
        
        switch type {
        case .present:
            guard let fromVCZoomTransitionAnimator = fromVC as? ZoomTransitionFromAnimateProtocol,
                let transitionImageView = fromVCZoomTransitionAnimator.transitionImageView() else {
                    return transitionContext.completeTransition(true)
            }
            presentAnimation(transitionContext: transitionContext,
                             transitionImageView: transitionImageView,
                             toView: toVC.view)
        case .dismiss:
            guard let fromVCZoomTransitionAnimator = fromVC as? ZoomTransitionToAnimateProtocol,
                let toVCZoomTransitionAnimator = toVC as? ZoomTransitionFromAnimateProtocol else {
                    return transitionContext.completeTransition(true)
            }
            dismissAnimation(fromVCZoomTransitionAnimatorProtocol: fromVCZoomTransitionAnimator,
                             toVCZoomTransitionAnimatorProtocol: toVCZoomTransitionAnimator,
                             transitionContext: transitionContext, fromView: fromVC.view)
        }
    }
    
    private func getViewController(using transitionContext: UIViewControllerContextTransitioning,
                                   key: UITransitionContextViewControllerKey) -> UIViewController? {
        let fromVC = transitionContext.viewController(forKey: key)
        if let navigationController = fromVC as? UINavigationController {
            return navigationController.viewControllers.last
        } else {
            return fromVC
        }
    }
    
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning,
                                  transitionImageView: UIImageView,
                                  toView: UIView) {
        let containerView = transitionContext.containerView
        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = toView.backgroundColor
        containerView.addSubview(maskView)
        
        let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
        transitionImageView.frame = convertedRect
        transitionImageView.contentMode = .scaleAspectFit
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:
                transitionImageView.frame.size.height *= containerView.frame.width / transitionImageView.frame.size.width
                transitionImageView.frame.size.width = containerView.frame.width
                transitionImageView.frame.origin.x = 0.0
                transitionImageView.frame.origin.y = (UIScreen.main.bounds.height) / 2 - transitionImageView.frame.size.height / 2
            case .landscapeLeft, .landscapeRight:
                transitionImageView.frame.size.width *= containerView.frame.height / transitionImageView.frame.size.height
                transitionImageView.frame.size.height = containerView.frame.height
                transitionImageView.frame.origin.x = containerView.frame.width / 2 - transitionImageView.frame.size.width / 2
                transitionImageView.frame.origin.y = 0.0
            case .unknown: break
            }
        }) { (finished) -> Void in
            maskView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            containerView.addSubview(toView)
            toView.overlay(on: containerView)
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(fromVCZoomTransitionAnimatorProtocol: ZoomTransitionToAnimateProtocol,
                                  toVCZoomTransitionAnimatorProtocol: ZoomTransitionFromAnimateProtocol,
                                  transitionContext: UIViewControllerContextTransitioning,
                                  fromView: UIView) {

        let transitionImageView = fromVCZoomTransitionAnimatorProtocol.transitionImageView
        let containerView = transitionContext.containerView
        let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
        transitionImageView.frame = convertedRect
        transitionImageView.contentMode = .scaleAspectFit
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
