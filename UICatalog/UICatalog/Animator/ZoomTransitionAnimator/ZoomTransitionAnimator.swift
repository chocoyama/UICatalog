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
    
    public enum BackgroundColor {
        case white
        case black
        
        var fromColor: UIColor {
            switch self {
            case .white: return UIColor(white: 1.0, alpha: 0.0)
            case .black: return UIColor(white: 0.0, alpha: 0.0)
            }
        }
        
        var toColor: UIColor {
            switch self {
            case .white: return UIColor(white: 1.0, alpha: 0.9)
            case .black: return UIColor(white: 0.0, alpha: 0.9)
            }
        }
    }
    
    private let type: AnimatorType
    private let backgroundColor: BackgroundColor
    
    public init(type: AnimatorType, backgroundColor: BackgroundColor) {
        self.type = type
        self.backgroundColor = backgroundColor
        super.init()
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
        // setup containerView
        let containerView = transitionContext.containerView
        containerView.backgroundColor = backgroundColor.fromColor
        
        // setup mask view
        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = toView.backgroundColor
        containerView.addSubview(maskView)
        
        // setup transitionImageView
        let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
        transitionImageView.frame = convertedRect
        transitionImageView.contentMode = .scaleAspectFit
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            containerView.backgroundColor = self.backgroundColor.toColor
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
            containerView.backgroundColor = .clear
            toView.backgroundColor = self.backgroundColor.toColor
            containerView.addSubview(toView)
            toView.overlay(on: containerView)
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(fromVCZoomTransitionAnimatorProtocol: ZoomTransitionToAnimateProtocol,
                                  toVCZoomTransitionAnimatorProtocol: ZoomTransitionFromAnimateProtocol,
                                  transitionContext: UIViewControllerContextTransitioning,
                                  fromView: UIView) {
        // setup containerView
        let containerView = transitionContext.containerView
        
        // setup transitionImageView
        let transitionImageView = fromVCZoomTransitionAnimatorProtocol.transitionImageView
        let convertedRect = transitionImageView.convert(transitionImageView.bounds, to: containerView)
        transitionImageView.frame = convertedRect
        transitionImageView.contentMode = .scaleAspectFit
        containerView.addSubview(transitionImageView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            containerView.backgroundColor = self.backgroundColor.fromColor
            transitionImageView.frame = toVCZoomTransitionAnimatorProtocol.previousFrame()
        }, completion: { (finished) -> Void in
            transitionImageView.removeFromSuperview()
            containerView.addSubview(fromView)
            toVCZoomTransitionAnimatorProtocol.didEndZoomTransiton()
            transitionContext.completeTransition(true)
        })
    }
}
