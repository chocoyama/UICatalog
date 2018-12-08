//
//  Switcher.swift
//  RotationImageView+ImageSwitcher
//
//  Created by takyokoy on 2017/06/30.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import Foundation

extension RotationImageView {
    
    class ImageSwitcher {
        
        private var displayManager: DisplayManager?
        private let animator = Animator()
        private var isFirstSwitch: Bool = true
        
        func setup(with resources: [PhotoResource]) -> [RotationImageItem] {
            displayManager = DisplayManager(resources: resources)
            return displayManager?.setup() ?? []
        }
        
        func append(_ resources: [PhotoResource]) {
            self.displayManager?.append(resources)
        }
        
        func switchImage(withDuration interval: TimeInterval, animation: RotationImageView.Animation?, completion: (() -> Void)?) {
            guard let displayManager = displayManager else { completion?(); return }
            
            if !isFirstSwitch {
                displayManager.loadNext()
            } else {
                isFirstSwitch = false
            }
            
            let orders: [Animator.Order]
            
            switch animation {
            case .some(.zoom(let scale)):
                displayManager.inactiveItems.forEach{ $0.hide() }
                displayManager.activeItem.show()
                
                orders = [
                    .init(item: displayManager.activeItem, animation: .zoom(duration: interval, scale: scale))
                ]
                
            case .some(.zoomFadeOut(let scale)):
                displayManager.inactiveItems.forEach{ $0.hide() }
                displayManager.activeItem.show()
                
                orders = [
                    .init(item: displayManager.activeItem, animation: .zoomFadeOut(duration: interval, scale: scale, fadeOutTime: interval * 0.3)),
                    .init(item: displayManager.readyItem, animation: .fadeIn(duration: interval * 0.3, delay: interval * 0.6))
                ]
                
                
            case .some(.fadeInOut(let animatePercent)):
                displayManager.inactiveItems.forEach{ $0.hide() }
                
                let duration = interval * animatePercent
                let delay = interval * (1 - animatePercent)
                
                orders = [
                    .init(item: displayManager.activeItem, animation: .fadeOut(duration: duration, delay: delay)),
                    .init(item: displayManager.readyItem, animation: .fadeIn(duration: duration, delay: delay))
                ]
                
            case .none:
                orders = []
            }
            
            animator.animate(orders: orders, completion: completion)
        }
    }

}
