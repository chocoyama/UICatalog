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
    var collectionView: UICollectionView! { get }
    var latestTransitionIndexPath: IndexPath? { get set }
    var selectedImage: UIImage? { get set }
}

extension ZoomTransitionFromAnimateProtocol {
    func transitionImageView() -> UIImageView? {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath),
            let image = selectedImage else { return nil }
        cell.isHidden = true
        let imageView = UIImageView(frame: getRectByIndexPath(indexPath: indexPath))
        imageView.image = image
        return imageView
    }
    
    func getRectByIndexPath(indexPath: IndexPath) -> CGRect {
        guard let cell = collectionView.cellForItem(at: indexPath),
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
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isHidden = false
    }
}
