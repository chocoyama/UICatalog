//
//  PresentationController.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2019/05/08.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension SemiModalPresentationTransitions {
    final class PresentationController: UIPresentationController {
        private let dismissTransitionController: SemiModalDismissTransitionController
        private var keyboardHeight: CGFloat = .leastNormalMagnitude
        
        init(
            presentedViewController: UIViewController,
            presenting presentingViewController: UIViewController?,
            dismissTransitionController: SemiModalDismissTransitionController
            ) {
            self.dismissTransitionController = dismissTransitionController
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillChangeFrameNotification,
                object: nil,
                queue: nil
            ) { [weak self] (notification) in
                guard let self = self else { return }
                self.keyboardHeight = notification.keyboardFrame?.height ?? 0
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.containerView?.setNeedsLayout()
                    self?.containerView?.layoutIfNeeded()
                }
            }
        }
        
        private lazy var overlayView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTap)))
            return view
        }()
        
        @objc private func overlayViewDidTap(sender: UITapGestureRecognizer) {
            dismissTransitionController.isInteractive = false
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            
            overlayView.addGestureRecognizer(UIPanGestureRecognizer(
                target: dismissTransitionController,
                action: #selector(SemiModalDismissTransitionController.observePanGesture(panGesture:)))
            )
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
            frame.origin.y = frame.maxY - height - keyboardHeight
            frame.size.height = height
            return frame
        }
        
        override func containerViewWillLayoutSubviews() {
            super.containerViewWillLayoutSubviews()
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
    }
}
