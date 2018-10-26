//
//  RotationImageView+Resource.swift
//  IntervalZoomImageView
//
//  Created by takyokoy on 2017/06/30.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import UIKit

// TODO: Kingfisherか何か入れる
extension RotationImageView {
    
    public enum Resource {
        case image(UIImage)
//        case url(URL)
//        case urlString(String)
        
        public func load(to rotationImageItem: RotationImageItem) {
            rotationImageItem.resetScale()
            load(to: rotationImageItem.imageView)
        }
        
        public func load(to imageView: UIImageView) {
            switch self {
            case .image(let image):
                imageView.image = image
//            case .url(let url):
//                imageView.sd_setImage(with: url)
//            case .urlString(let urlString):
//                imageView.sd_setImage(with: URL(string: urlString)!)
            }
        }
    }

}
