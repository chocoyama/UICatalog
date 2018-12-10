//
//  ZoomTransitionAnimatorDestinationViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol ImageDetailViewControllerDelegate: class {
    func imageDetailViewController(_ imageDetailViewController: ImageDetailViewController,
                                   shouldLoadImageUrl url: URL,
                                   to imageView: UIImageView)
}

open class ImageDetailViewController: UIViewController, ZoomTransitionToAnimateProtocol {
    
    open weak var delegate: ImageDetailViewControllerDelegate?
    
    public let transitionImageView: UIImageView
    private let defaultImageFrame: CGRect
    
    private let initialElement: (image: UIImage, index: Int)
    private let resources: [PhotoResource]
    private let backgroundColor: ZoomTransitionAnimator.BackgroundColor
    
    @IBOutlet weak var pageCounterLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailCollectionView: UICollectionView! {
        didSet {
            ImageDetailCollectionViewCell.register(for: detailCollectionView, bundle: .current)
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
    
    public init(initialElement: (image: UIImage, index: Int),
                resources: [PhotoResource],
                backgroundColor: ZoomTransitionAnimator.BackgroundColor) {
        self.initialElement = initialElement
        self.backgroundColor = backgroundColor
        
        self.resources = resources
        
        self.defaultImageFrame = CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height)
        let imageView = UIImageView(frame: defaultImageFrame)
        imageView.image = initialElement.image
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
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
        showDetailForSmoothDisplaying()
    }
    
    private func configureSubviews() {
        // panGesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didRecognizedPanGestureOnImageView(sender:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        // pageCounterLabel, closeButton
        pageCounterLabel.text = "1 / \(resources.count)"
        switch backgroundColor {
        case .white:
            pageCounterLabel.textColor = .black
            closeButton.setImage(UIImage(named: "close/black", in: .current, compatibleWith: nil),
                                 for: .normal)
        case .black:
            pageCounterLabel.textColor = .white
            closeButton.setImage(UIImage(named: "close/white", in: .current, compatibleWith: nil),
                                 for: .normal)
        }
        
        // transitionImageView
        view.addSubview(transitionImageView)
    }
    
    private func showDetailForSmoothDisplaying() {
        self.transitionImageView.isHidden = false
        self.detailCollectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectThumbnailItem(at: IndexPath(item: self.initialElement.index, section: 0),
                                     animatedDetail: false,
                                     animatedThumbnail: true)
            self.transitionImageView.isHidden = true
            self.detailCollectionView.isHidden = false
        }
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
    
    private func requestSetImage(_ urlString: String, to imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        requestSetImage(url, to: imageView)
    }
    
    private func requestSetImage(_ url: URL, to imageView: UIImageView) {
        delegate?.imageDetailViewController(self,
                                            shouldLoadImageUrl: url,
                                            to: imageView)
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
        return resources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case thumbnailCollectionView:
            switch resources[indexPath.item] {
            case .image(let image):
                return ImageDetailThumbnailCollectionViewCell
                    .dequeue(from: collectionView, indexPath: indexPath)
                    .configure(for: image)
            case .url(let url):
                let cell = ImageDetailThumbnailCollectionViewCell.dequeue(from: collectionView, indexPath: indexPath)
                requestSetImage(url, to: cell.imageView)
                return cell
            case .urlString(let urlString):
                let cell = ImageDetailThumbnailCollectionViewCell.dequeue(from: collectionView, indexPath: indexPath)
                requestSetImage(urlString, to: cell.imageView)
                return cell
            }
        case detailCollectionView:
            switch resources[indexPath.item] {
            case .image(let image):
                return ImageDetailCollectionViewCell
                    .dequeue(from: collectionView, indexPath: indexPath)
                    .configure(for: image)
            case .url(let url):
                let cell = ImageDetailCollectionViewCell.dequeue(from: collectionView, indexPath: indexPath)
                requestSetImage(url, to: cell.imageView)
                return cell
            case .urlString(let urlString):
                let cell = ImageDetailCollectionViewCell.dequeue(from: collectionView, indexPath: indexPath)
                requestSetImage(urlString, to: cell.imageView)
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

extension ImageDetailViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case thumbnailCollectionView:
            selectThumbnailItem(at: indexPath, animatedDetail: true, animatedThumbnail: true)
        case detailCollectionView:
            break
        default:
            break
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case thumbnailCollectionView: break
        case detailCollectionView: selectDetailItem()
        default: break
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case thumbnailCollectionView: break
        case detailCollectionView: scrolledDetailItem()
        default: break
        }
    }
    
    private func selectThumbnailItem(at indexPath: IndexPath, animatedDetail: Bool, animatedThumbnail: Bool) {
        detailCollectionView.selectItem(at: indexPath,
                                        animated: animatedDetail,
                                        scrollPosition: .centeredHorizontally)
        thumbnailCollectionView.selectItem(at: indexPath,
                                           animated: animatedThumbnail,
                                           scrollPosition: .centeredHorizontally)
        
        pageCounterLabel.text = "\(indexPath.item + 1) / \(resources.count)"
        updateTransitionImageView(atIndex: indexPath.item)
    }
    
    private func selectDetailItem() {
        guard let indexPath = detailCollectionView.centerIndexPath else { return }
        updateTransitionImageView(atIndex: indexPath.item)
    }
    
    private func scrolledDetailItem() {
        guard let indexPath = detailCollectionView.centerIndexPath else { return }
        pageCounterLabel.text = "\(indexPath.item + 1) / \(resources.count)"
        thumbnailCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func updateTransitionImageView(atIndex index: Int) {
        switch resources[index] {
        case .image(let image): transitionImageView.image = image
        case .url(let url): requestSetImage(url, to: transitionImageView)
        case .urlString(let urlString): requestSetImage(urlString, to: transitionImageView)
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
            return collectionView.frame.size
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

