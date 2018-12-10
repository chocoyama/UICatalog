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
        if transitionImageView.contentMode == .scaleAspectFill {
            transitionImageView.frame = adjustedFrameForScaleAspectFill(originalFrame: transitionImageView.frame,
                                                                        imageSize: transitionImageView.image?.size ?? .zero)
        }
        transitionImageView.contentMode = .scaleAspectFit
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            containerView.backgroundColor = self.backgroundColor.toColor
            transitionImageView.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.width, height: containerView.frame.height)
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
        
        var toFrame = toVCZoomTransitionAnimatorProtocol.previousFrame()
        if toVCZoomTransitionAnimatorProtocol.initialContentMode == .scaleAspectFill {
            toFrame = adjustedFrameForScaleAspectFill(originalFrame: toVCZoomTransitionAnimatorProtocol.previousFrame(),
                                                      imageSize: transitionImageView.image?.size ?? .zero)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            containerView.backgroundColor = self.backgroundColor.fromColor
            transitionImageView.frame = toFrame
        }, completion: { (finished) -> Void in
            transitionImageView.removeFromSuperview()
            containerView.addSubview(fromView)
            toVCZoomTransitionAnimatorProtocol.didEndZoomTransiton()
            transitionContext.completeTransition(true)
        })
    }
    
    private func adjustedFrameForScaleAspectFill(originalFrame: CGRect, imageSize: CGSize) -> CGRect {
        if imageSize.height == imageSize.width {
            return originalFrame
        }
        
        var toFrame = originalFrame
        
        let initialWidth = originalFrame.size.width
        let initialHeight = originalFrame.size.height
        
        let multiplier = imageSize.height > imageSize.width ? (imageSize.height / imageSize.width) : (imageSize.width / imageSize.height)
        toFrame.size.width *= multiplier
        toFrame.size.height *= multiplier
        
        toFrame.origin.x -= (toFrame.size.width - initialWidth) / 2
        toFrame.origin.y -= (toFrame.size.height - initialHeight) / 2
        
        return toFrame
    }
}
