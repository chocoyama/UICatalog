//
//  RotationImageView.swift
//  IntervalZoomImageView
//
//  Created by takyokoy on 2017/06/26.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import UIKit

/// アニメーションを伴って複数の画像を繰り返し表示続けるView
///
/// 使い方
/// 1. Storyboard, XibでRotationImageViewを配置する or ソースコードでインスタンス化して配置する
/// 2. 繰り返し表示するリソースを登録する
/// ```
/// rotationImageView.resources = [
///     .image(UIImage(named: "hoge")),
///     .url(URL(string: "https://hoge.png")),
///     .urlString("https://fuga.png")
/// ]
/// ```
///
/// 3. 画像の切り替わり間隔やアニメーションの種類を指定する
/// ```
/// rotationImageView.interval = 7.0
/// rotationImageView.animation = .zoomFadeOut(scale: 1.4)
/// ```
///
/// 4. セットアップを完了させる
/// ```
/// rotaionImageView.setup()
/// ```
///
/// 5. ローテーション処理を開始する
/// ```
/// rotationImageView.startRotation()
/// ```
open class RotationImageView: UIView {
    
    public enum Animation {
        case zoom(scale: CGFloat)
        case zoomFadeOut(scale: CGFloat)
        case fadeInOut(animatePercent: Double)
    }
    
    private static let defaultTimeInterval: TimeInterval = 5
    fileprivate var switcher = ImageSwitcher()
    
    open var resources = [Resource]()
    open var interval: TimeInterval = defaultTimeInterval
    open var animation: Animation?
    
    fileprivate(set) var isRunning = false
    fileprivate var stopFlag = false
    
    open func setup() {
        guard let firestResource = resources.first else {
            return
        }
        
        let imageItems = switcher.setup(with: [firestResource])
        add(imageItems)
    }
    
    open func startRotation() {
        if resources.isEmpty {
            return
        }
        
        let imageItems = switcher.setup(with: resources)
        add(imageItems)
        
        isRunning = true
        stopFlag = false
        rotation()
    }
    
    open func stopRotation() {
        isRunning = false
        stopFlag = true
    }
    
    open func reset() {
        stopRotation()
        subviews.forEach{ $0.removeFromSuperview() }
        switcher = ImageSwitcher()
        resources = []
        interval = RotationImageView.defaultTimeInterval
        animation = nil
    }
    
    open func append(_ resources: [Resource]) {
        switcher.append(resources)
    }

}

extension RotationImageView {
    
    fileprivate func add(_ items: [RotationImageItem]) {
        self.subviews.forEach { $0.removeFromSuperview() }
        items.forEach { $0.stick(to: self) }
    }
    
    fileprivate func rotation() {
        if stopFlag {
            return
        }
        
        stopFlag = true
        switcher.switchImage(withDuration: interval, animation: animation) { [weak self] in
            self?.stopFlag = false
            self?.rotation()
        }
    }
    
}

extension UIView {
    
    fileprivate func stick(to view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
    }
    
}
