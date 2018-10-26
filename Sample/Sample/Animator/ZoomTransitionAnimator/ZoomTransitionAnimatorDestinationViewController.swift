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
    
    var transitionImageView: UIImageView?
    private let image: UIImage
    private let defaultImageFrame: CGRect
    
    init(image: UIImage) {
        self.image = image
        
        let screenBounds = UIScreen.main.bounds
        let height: CGFloat = image.size.height * (screenBounds.width / image.size.width)
        let width: CGFloat = screenBounds.width
        let x: CGFloat = 0
        let y: CGFloat = (screenBounds.height + 20) / 2 - height / 2
        defaultImageFrame = CGRect(x: x, y: y, width: width, height: height)
        
        super.init(nibName: "ZoomTransitionAnimatorDestinationViewController", bundle: nil)
        
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = createImageView(with: image)
        self.transitionImageView = imageView
        self.view.addSubview(imageView)
    }
    
    func reset() {
        UIView.animate(withDuration: 0.2) {
            self.transitionImageView?.frame = self.defaultImageFrame
        }
    }
    
    private func createImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: defaultImageFrame)
        imageView.image = image
        imageView.backgroundColor = .white
        addPanGesture(to: imageView)
        
        return imageView
    }
    
    @discardableResult
    private func addPanGesture(to imageView: UIImageView) -> UIImageView {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                              action: #selector(didRecognizedPanGestureOnImageView(sender:))))
        return imageView
    }
    
    @objc func didRecognizedPanGestureOnImageView(sender: UIPanGestureRecognizer) {
        guard let transitionImageView = transitionImageView else { return }
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
