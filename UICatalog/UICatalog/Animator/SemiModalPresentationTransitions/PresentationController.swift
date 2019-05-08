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

}
