//
//  SemiModalPresentationTransitions.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/07.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

public final class SemiModalPresentationTransitions: NSObject, UIViewControllerTransitioningDelegate {
    public enum Animation {
        case system
        case custom
    }
    let dismissTransitionController: SemiModalDismissTransitionController
    let animation: Animation
    
    public init(viewController: UIViewController, animation: Animation) {
        dismissTransitionController = SemiModalDismissTransitionController(viewController: viewController)
        self.animation = animation
    }
    
    // MARK: - Presentation
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, dismissTransitionController: dismissTransitionController)
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
    
    final class PresentationController: UIPresentationController {
        let dismissTransitionController: SemiModalDismissTransitionController
        init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dismissTransitionController: SemiModalDismissTransitionController) {
            self.dismissTransitionController = dismissTransitionController
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        }
        
        private lazy var overlayView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTap)))
            return view
        }()
        
        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            overlayView.addGestureRecognizer(UIPanGestureRecognizer(target: dismissTransitionController, action: #selector(SemiModalDismissTransitionController.observePanGesture(panGesture:))))
            
            overlayView.frame = containerView?.frame ?? .zero
            containerView?.insertSubview(overlayView, at: 0)
            overlayView.alpha = 0
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
                self?.overlayView.alpha = 0.5
                }, completion: {(_) in })
        }
        
        override func dismissalTransitionWillBegin() {
            super.dismissalTransitionWillBegin()
            
            if dismissTransitionController.isInteractive {
                
            } else {
                presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
                    self?.overlayView.alpha = 0
                    }, completion: nil)
            }
        }
        
        override var frameOfPresentedViewInContainerView: CGRect {
            var frame = super.frameOfPresentedViewInContainerView
            let height = presentedViewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            frame.origin.y = frame.maxY - height
            frame.size.height = height
            return frame
        }
        
        override func containerViewWillLayoutSubviews() {
            super.containerViewWillLayoutSubviews()
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
        
        @objc private func overlayViewDidTap(sender: UITapGestureRecognizer) {
            dismissTransitionController.isInteractive = false
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
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

class NoAnimatedAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0 }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}
