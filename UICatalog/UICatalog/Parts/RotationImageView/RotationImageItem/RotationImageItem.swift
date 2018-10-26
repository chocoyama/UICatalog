//
//  RotationImageItem.swift
//  YPointAlert
//
//  Created by takyokoy on 2017/06/27.
//  Copyright © 2017年 Yahoo! JAPAN. All rights reserved.
//

import UIKit

/// ローテーションする画像の1枚分を担うView。
/// 表示制御やアニメーションなどの機能を持つ。
open class RotationImageItem: UIView, XibInitializable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        setXibView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
    }
    
    open var isVisible: Bool {
        return self.alpha == 1.0
    }
    
    open func show() {
        self.alpha = 1.0
    }
    
    open func hide() {
        self.alpha = 0.0
    }
    
    open func toggle() {
        isVisible ? hide() : show()
    }
    
    open func resetScale() {
        scrollView.zoomScale = 1.0
    }
}

// MARK:- Zoom
extension RotationImageItem {
    open func zoom(withDuration duration: TimeInterval, scale: CGFloat, completion: ((Bool) -> Void)?) {
        resetScale()
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.scrollView.zoomScale = scale
        }, completion: completion)
    }
    
    open func zoom(withDuration duration: TimeInterval, scale: CGFloat, fadeOutTime: TimeInterval, completion: ((Bool) -> Void)?) {
        resetScale()
        
        let group = DispatchGroup()
        let queue = DispatchQueue.main
        
        (0..<2).forEach{ _ in group.enter() }
        
        queue.async(group: group) { [weak self] in
            self?.zoom(withDuration: duration, scale: scale) { _ in
                group.leave()
            }
        }
        
        queue.async(group: group) { [weak self] in
            self?.fadeOut(withDuration: fadeOutTime, delay: duration - fadeOutTime) { _ in
                group.leave()
            }
        }
        
        group.notify(queue: queue) { 
            completion?(true)
        }
    }
}

// MARK:- FadeIn/Fadeout
extension RotationImageItem {
    open func fadeIn(withDuration duration: TimeInterval, completion: ((Bool) -> Void)?) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 1.0
        }, completion: completion)
    }
    
    open func fadeIn(withDuration duration: TimeInterval, delay: TimeInterval, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeIn(withDuration: duration, completion: completion)
        }
    }
    
    open func fadeOut(withDuration duration: TimeInterval, completion: ((Bool) -> Void)?) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: completion)
    }
    
    open func fadeOut(withDuration duration: TimeInterval, delay: TimeInterval, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.fadeOut(withDuration: duration, completion: completion)
        }
    }
}

extension RotationImageItem: UIScrollViewDelegate {
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
