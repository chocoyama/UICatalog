//
//  ZoomTransitionAnimatorDestinationViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class ImageDetailViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    public let transitionImageView: UIImageView
    private let defaultImageFrame: CGRect
    
    private let images: [UIImage]
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            ImageDetailThumbnailCollectionViewCell.register(for: collectionView, bundle: .current)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    public init(images: [UIImage]) {
        self.images = images
        self.defaultImageFrame = images[0].screenAdjustFrame
        
        let imageView = UIImageView(frame: defaultImageFrame)
        imageView.image = images[0]
        imageView.backgroundColor = .white
        self.transitionImageView = imageView
        
        super.init(nibName: "ImageDetailViewController", bundle: .current)
        
        self.transitionImageView.addPanGesture(target: self,
                                               action: #selector(didRecognizedPanGestureOnImageView(sender:)))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        self.view.addSubview(transitionImageView)
    }
    
    open func reset() {
        UIView.animate(withDuration: 0.2) {
            self.transitionImageView.frame = self.defaultImageFrame
        }
    }
    
    @objc open func didRecognizedPanGestureOnImageView(sender: UIPanGestureRecognizer) {
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

extension ImageDetailViewController: ZoomTransitionToAnimateProtocol {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .present)
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .dismiss)
    }
}

extension ImageDetailViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImageDetailThumbnailCollectionViewCell
            .dequeue(from: collectionView, indexPath: indexPath)
            .configure(for: images[indexPath.item])
    }
}

extension ImageDetailViewController: UICollectionViewDelegate {}

extension ImageDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = collectionView.bounds.height
        return CGSize(width: collectionViewHeight, height: collectionViewHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
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

