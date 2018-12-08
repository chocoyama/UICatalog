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
    private let backgroundColor: ZoomTransitionAnimator.BackgroundColor
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailCollectionView: UICollectionView! {
        didSet {
            ImageDetailThumbnailCollectionViewCell.register(for: detailCollectionView, bundle: .current)
            detailCollectionView.dataSource = self
            detailCollectionView.delegate = self
        }
    }
    @IBOutlet weak var thumbnailCollectionView: UICollectionView! {
        didSet {
            ImageDetailThumbnailCollectionViewCell.register(for: thumbnailCollectionView, bundle: .current)
            thumbnailCollectionView.dataSource = self
            thumbnailCollectionView.delegate = self
        }
    }
    
    public init(images: [UIImage], backgroundColor: ZoomTransitionAnimator.BackgroundColor) {
        self.images = images
        self.backgroundColor = backgroundColor
        self.defaultImageFrame = images[0].screenAdjustFrame
        
        let imageView = UIImageView(frame: defaultImageFrame)
        imageView.image = images[0]
        imageView.backgroundColor = .clear
        self.transitionImageView = imageView
        
        super.init(nibName: "ImageDetailViewController", bundle: .current)
        prepareAnimation()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareAnimation() {
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = .clear
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        configureSubviews()
    }
    
    private func configureSubviews() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didRecognizedPanGestureOnImageView(sender:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        switch backgroundColor {
        case .white: closeButton.imageView?.image = UIImage(named: "close/black")
        case .black: closeButton.imageView?.image = UIImage(named: "close/white")
        }
        view.addSubview(transitionImageView)
        transitionImageView.isHidden = true
    }
    
    open func reset() {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = self.backgroundColor.toColor
            self.transitionImageView.isHidden = true
            self.detailCollectionView.isHidden = false
            self.thumbnailCollectionView.alpha = 1.0
            self.closeButton.alpha = 1.0
            self.transitionImageView.frame = self.defaultImageFrame
        }
    }
    
    @objc open func didRecognizedPanGestureOnImageView(sender: UIPanGestureRecognizer) {
        let view = sender.view
        let translation = sender.translation(in: view)
        let position = CGPoint(x: translation.x + self.defaultImageFrame.midX,
                               y: translation.y + self.defaultImageFrame.midY)
        let threshold: CGFloat = 180
        let fraction = abs(translation.y / threshold)
        
        switch sender.state {
        case .began:
            transitionImageView.isHidden = false
            detailCollectionView.isHidden = true
            transitionImageView.frame = self.defaultImageFrame
        case .changed:
            self.view.backgroundColor = backgroundColor.toColor.withAlphaComponent(0.9 - fraction * 0.6)
            self.thumbnailCollectionView.alpha = 1.0 - fraction
            self.closeButton.alpha = 1.0 - fraction
            transitionImageView.center = position
        case .ended:
            if fraction >= 1.0 {
                dismiss(animated: true, completion: nil)
            } else {
                reset()
            }
        default:
            break
        }
    }
    
    @IBAction func didTappedCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UIViewControllerTransitioningDelegate {
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .present, backgroundColor: backgroundColor)
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomTransitionAnimator(type: .dismiss, backgroundColor: backgroundColor)
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

extension ImageDetailViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case thumbnailCollectionView:
            [detailCollectionView, thumbnailCollectionView].forEach {
                $0.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
            self.transitionImageView.image = self.images[indexPath.item]
        case detailCollectionView:
            break
        default:
            break
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case thumbnailCollectionView:
            break
        case detailCollectionView:
            if let indexPath = detailCollectionView.centerIndexPath {
                self.transitionImageView.image = self.images[indexPath.item]
            }
        default:
            break
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case thumbnailCollectionView:
            break
        case detailCollectionView:
            if let indexPath = detailCollectionView.centerIndexPath {
                thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        default:
            break
        }
    }
}

extension ImageDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case thumbnailCollectionView:
            let collectionViewHeight = collectionView.bounds.height
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        case detailCollectionView:
            return images[indexPath.item].screenAdjustFrame.size
        default:
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case thumbnailCollectionView: return UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        case detailCollectionView: return .zero
        default: return .zero
        }
    }
}

extension ImageDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        let tappedPoint = panGestureRecognizer.location(in: gestureRecognizer.view)
        let tappedCollectionViewLocation = detailCollectionView.frame.contains(tappedPoint)
        
        let translation = panGestureRecognizer.translation(in: gestureRecognizer.view)
        let isVertivalSwipe = !(sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1)
        
        return tappedCollectionViewLocation && isVertivalSwipe
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

