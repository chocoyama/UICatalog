//
//  ZoomTransitionAnimatorDestinationViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class ImageDetailViewController: UIViewController, ZoomTransitionToAnimateProtocol {
    
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
        imageView.backgroundColor = .clear
        self.transitionImageView = imageView
        
        super.init(nibName: "ImageDetailViewController", bundle: .current)
        
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = .clear
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
        UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.4) {
            self.transitionImageView.frame = self.defaultImageFrame
        }.startAnimation()
    }
    
    @objc open func didRecognizedPanGestureOnImageView(sender: UIPanGestureRecognizer) {
        let view = sender.view
        let translation = sender.translation(in: view)
        let position = CGPoint(x: translation.x + self.defaultImageFrame.midX, y: translation.y + self.defaultImageFrame.midY)
        
        switch sender.state {
        case .began:
            transitionImageView.frame = self.defaultImageFrame
        case .changed:
            transitionImageView.center = position
        case .ended:
            if abs(transitionImageView.center.y - defaultImageFrame.midY) >= 200 {
                dismiss(animated: true, completion: nil)
            } else {
                reset()
            }
        default:
            break
        }
    }
}

extension ImageDetailViewController: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .present, backgroundColor: .white)
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .dismiss, backgroundColor: .white)
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
        let y: CGFloat = (screenBounds.height) / 2 - height / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
