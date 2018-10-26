//
//  ZoomTransitionAnimatorDestinationViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class ZoomTransitionAnimatorDestinationViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transitionImageView: UIImageView
    private let defaultImageFrame: CGRect
    
    init(image: UIImage) {
        self.defaultImageFrame = image.screenAdjustFrame
        
        let imageView = UIImageView(frame: defaultImageFrame)
        imageView.image = image
        imageView.backgroundColor = .white
        self.transitionImageView = imageView
        
        super.init(nibName: "ZoomTransitionAnimatorDestinationViewController", bundle: nil)
        
        self.transitionImageView.addPanGesture(target: self,
                                               action: #selector(didRecognizedPanGestureOnImageView(sender:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        self.view.addSubview(transitionImageView)
    }
    
    func reset() {
        UIView.animate(withDuration: 0.2) {
            self.transitionImageView.frame = self.defaultImageFrame
        }
    }
    
    @objc func didRecognizedPanGestureOnImageView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let view = sender.view
            let translationPoint = sender.translation(in: view)
            transitionImageView.frame.origin.y = defaultImageFrame.origin.y + translationPoint.y
        case .ended:
            if transitionImageView.frame.origin.y == defaultImageFrame.origin.y {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        default: break
        }
    }
}

extension ZoomTransitionAnimatorDestinationViewController: ZoomTransitionToAnimateProtocol {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .dismiss)
    }
}

private extension UIImageView {
    @discardableResult
    func addPanGesture(target: Any?, action: Selector?) -> UIImageView {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: target, action: action))
        return self
    }
}

private extension UIImage {
    var screenAdjustFrame: CGRect {
        let screenBounds = UIScreen.main.bounds
        let height: CGFloat = self.size.height * (screenBounds.width / self.size.width)
        let width: CGFloat = screenBounds.width
        let x: CGFloat = 0
        let y: CGFloat = (screenBounds.height + 20) / 2 - height / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
