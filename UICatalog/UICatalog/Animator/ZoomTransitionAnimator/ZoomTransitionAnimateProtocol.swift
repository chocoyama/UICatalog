//
//  ZoomTransitionAnimateProtocol.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol ZoomTransitionToAnimateProtocol {
    var transitionImageView: UIImageView { get }
}

public protocol ZoomTransitionFromAnimateProtocol {
    var selectedCollectionView: UICollectionView? { get }
    var latestTransitionIndexPath: IndexPath? { get set }
    var selectedImage: UIImage? { get set }
    var initialContentMode: UIView.ContentMode { get set }
}

extension ZoomTransitionFromAnimateProtocol {
    func transitionImageView() -> UIImageView? {
        guard let indexPath = selectedCollectionView?.indexPathsForSelectedItems?.first,
            let cell = selectedCollectionView?.cellForItem(at: indexPath),
            let image = selectedImage else { return nil }
        cell.isHidden = true
        let imageView = UIImageView(frame: getRectByIndexPath(indexPath: indexPath))
        imageView.image = image
        imageView.contentMode = initialContentMode
        return imageView
    }
    
    func getRectByIndexPath(indexPath: IndexPath) -> CGRect {
        guard let cell = selectedCollectionView?.cellForItem(at: indexPath),
            let rootView = UIApplication.shared.keyWindow?.rootViewController?.view else { return CGRect.zero }
        let convertedRect = cell.convert(cell.bounds, to: rootView)
        return convertedRect
    }
    
    func previousFrame() -> CGRect {
        guard let indexPath = latestTransitionIndexPath else { return CGRect.zero }
        return getRectByIndexPath(indexPath: indexPath)
    }
    
    func didEndZoomTransiton() {
        guard let indexPath = latestTransitionIndexPath else { return }
        let cell = selectedCollectionView?.cellForItem(at: indexPath)
        cell?.isHidden = false
    }
}
