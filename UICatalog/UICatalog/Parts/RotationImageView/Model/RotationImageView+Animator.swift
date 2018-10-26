//
//  RotationImageView+Animator.swift
//  IntervalZoomImageView
//
//  Created by takyokoy on 2017/07/04.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import UIKit

extension RotationImageView {
    
    struct Animator {
        
        enum Animation {
            case zoom(duration: TimeInterval, scale: CGFloat)
            case zoomFadeOut(duration: TimeInterval, scale: CGFloat, fadeOutTime: TimeInterval)
            case fadeIn(duration: TimeInterval, delay: TimeInterval)
            case fadeOut(duration: TimeInterval, delay: TimeInterval)
        }
        
        struct Order {
            let item: RotationImageItem
            let animation: Animation
        }
        
        func animate(orders: [Order], completion: (() -> Void)?) {
            let group = DispatchGroup()
            let queue = DispatchQueue.main
            
            for order in orders {
                group.enter()
                queue.async(group: group) {
                    switch order.animation {
                    case .zoom(let duration, let scale):
                        order.item.zoom(withDuration: duration, scale: scale) { _ in group.leave() }
                    case .zoomFadeOut(let duration, let scale, let fadeOutTime):
                        order.item.zoom(withDuration: duration, scale: scale, fadeOutTime: fadeOutTime) { _ in group.leave() }
                    case .fadeIn(let duration, let delay):
                        order.item.fadeIn(withDuration: duration, delay: delay) { _ in group.leave() }
                    case .fadeOut(let duration, let delay):
                        order.item.fadeOut(withDuration: duration, delay: delay) { _ in group.leave() }
                    }
                }
            }
            
            group.notify(queue: queue) {
                completion?()
            }
        }
        
    }

}
