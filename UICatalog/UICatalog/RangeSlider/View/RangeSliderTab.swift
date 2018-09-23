//
//  RangeSliderTab.swift
//  YPointAlert
//
//  Created by Takuya Yokoyama on 2018/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import UIKit

@IBDesignable
open class RangeSliderTab: UIView, RangeSliderViewInitializable {
    
    public enum `Type` {
        case left
        case right
    }
    
    public enum Mode {
        case `default`
        case valueFixed(Int)
    }
    
    @IBOutlet open weak var tab: UIView! {
        didSet {
            tab.layer.cornerRadius = tab.frame.width / 2
            tab.layer.borderColor = UIColor.lightGray.cgColor
            tab.layer.borderWidth = tabBorderWidth
        }
    }
    @IBOutlet open weak var label: CustomEdgeInsetsLabel!
    @IBOutlet open weak var labelBaseView: UIView!
    @IBOutlet open var contentView: UIView!
    
    fileprivate var type: Type = .left // Typeは初期化時に1度だけ変更される
    fileprivate var mode: Mode = .default // Modeは表示値を強制的に書き換えた時に変更される。
    weak open var dependentSlider: RangeSlider?
    
    public let tabBorderWidth: CGFloat = 1.0
    
    open var allHeight: CGFloat {
        return tab.frame.maxY
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
    
    open func initialize(type: Type, dependentSlider: RangeSlider) {
        self.type = type
        self.dependentSlider = dependentSlider
    }
    
    /** ラベルの表示を引数の値をもとにして強制的に書き換える */
    open func forceUpdateLabel(price: Int) {
        mode = .valueFixed(price)
        label.attributedText = NSAttributedString(string: "\(price)")
    }
}

typealias RangeSliderTabDynamicValue = RangeSliderTab
extension RangeSliderTabDynamicValue {
    
    /** タッチを認識する範囲を返す */
    open var touchAvailableFrame: CGRect {
        self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        let result = self.frame
        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        return result
    }
    
    /** 
     現在のタブの位置に対応する値を返す。
     規定値以外で強制的に値を書き換えている場合はその値をそのまま返す。
     */
    open var value: Int {
        if case .valueFixed(let value) = mode {
            return value
        }
        guard let slider = dependentSlider else { return 0 }
        
        let value: Int
        switch type {
        case .left:
            let locationX = slider.leftMarginConstraint.constant + slider.leftRangeBarWidthConstraint.constant
            value = slider.dynamicValue(locationX: locationX) ?? slider.rangeValue.minValue
        case .right:
            let locationX = slider.frame.width - (slider.rightMarginConstraint.constant + slider.rightRangeBarWidthConstraint.constant)
            value = slider.dynamicValue(locationX: locationX) ?? slider.rangeValue.maxValue
        }
        return value
    }
    
    /** タブ上のラベルの表示文字列を返す */
    open var text: String {
        return "\(value)"
    }
    
    /** タブの位置に対応する値が全体の値の中で何番目かを返す */
    open var currentIndex: Int {
        guard let slider = dependentSlider else { return 0 }
        switch type {
        case .left: return slider.rangeValue.indexFromValue(value: value) ?? 0
        case .right: return slider.rangeValue.indexFromValue(value: value) ?? slider.rangeValue.maxValue
        }
    }
    
    /** 左のタブが右のタブを超えない&&右のタブが左のタブを超えないために、動かすことのできる最大値を動的に返す */
    open var dynamicMaxPoint: CGFloat {
        guard let slider = dependentSlider else { return 0.0 }
        let mainBarFirstMinX = slider.leftMarginConstraint.constant + slider.leftRangeBarDefaultWidth
        switch type {
        case .left: return slider.dx * CGFloat(slider.rightTab.currentIndex - 1) + mainBarFirstMinX
        case .right: return slider.dx * CGFloat(slider.leftTab.currentIndex + 1) + mainBarFirstMinX
        }
    }
    
    fileprivate var willChangedText: Bool {
        guard let slider = dependentSlider else { return false }
        let currentText = (type == .left) ? slider.leftTab.label.text : slider.rightTab.label.text
        let nextText = text
        return currentText != nextText
    }
}

typealias RangeSliderTabMovingBehavior = RangeSliderTab
extension RangeSliderTabMovingBehavior {
    
    /** translationPointX分タブを移動する */
    open func move(translationPointX: CGFloat) {
        mode = .default
        guard let slider = dependentSlider else { return }
        switch type {
        case .left:
            slider.leftRangeBarWidthConstraint.constant += translationPointX
            if willChangedText { slider.noticeChanged() }
            slider.leftTab.label.text = text
        case .right:
            slider.rightRangeBarWidthConstraint.constant += translationPointX
            if willChangedText { slider.noticeChanged() }
            slider.rightTab.label.text = text
        }
    }
    
    /** pointXまでタブを移動する */
    open func moveAtPoint(pointX: CGFloat) {
        guard let slider = dependentSlider, let _ = slider.dynamicValue(locationX: pointX) else {
            resetPosition()
            return
        }
        let dx = (type == .left) ? pointX - slider.leftRangeBarWidthConstraint.constant - slider.leftMarginConstraint.constant
            : slider.frame.width - pointX - slider.rightRangeBarWidthConstraint.constant - slider.rightMarginConstraint.constant
        move(translationPointX: dx)
    }
    
    /** valueの値までタブを移動する */
    open func moveAtValue(value: Int) {
        guard let slider = dependentSlider else { return }
        if slider.rangeValue.values.contains(value) {
            let positionX = slider.dynamicPositionX(value: value)
            moveAtPoint(pointX: positionX)
        } else {
            if let range = slider.rangeValue.rangeFromNotExistValue(value: value) {
                let rightPositionX = slider.dynamicPositionX(value: range.right)
                let leftPositionX = slider.dynamicPositionX(value: range.left)
                let positionX = rightPositionX - ((rightPositionX - leftPositionX) / 2)
                moveAtPoint(pointX: positionX)
            }
        }
    }
    
    /** タブのポジションを初期値に戻す */
    open func resetPosition() {
        mode = .default
        guard let slider = dependentSlider else { return }
        switch type {
        case .left:
            slider.leftRangeBarWidthConstraint.constant = slider.leftRangeBarDefaultWidth
            slider.leftTab.label.text = text
        case .right:
            slider.rightRangeBarWidthConstraint.constant = slider.rightRangeBarDefaultWidth
            slider.rightTab.label.text = text
        }
    }
    
}


typealias RangeSliderTabAnimationBehavior = RangeSliderTab
extension RangeSliderTabAnimationBehavior {
    
    public enum AnimationDuration: TimeInterval {
        case long = 0.1
        case short = 0.08
    }
    
    public enum AnimationZoomScale: CGFloat {
        case animating = 2.5
        case picking = 2.0
    }
    
    private func createLabelTransform() -> (animating: CGAffineTransform, picking: CGAffineTransform, normal: CGAffineTransform) {
        let animatingZoomScale = AnimationZoomScale.animating.rawValue
        let animatingFloatingPoint = -((label.frame.height * animatingZoomScale - label.frame.height) / 2)
        let animatingTransform = CGAffineTransform(a: animatingZoomScale, b: 0, c: 0, d: animatingZoomScale, tx: 0, ty: animatingFloatingPoint)
        
        let pickingZoomScale = AnimationZoomScale.picking.rawValue
        let pickingFloatingPoint = -((label.frame.height * pickingZoomScale - label.frame.height) / 2)
        let pickingTransform = CGAffineTransform(a: pickingZoomScale, b: 0, c: 0, d: pickingZoomScale, tx: 0, ty: pickingFloatingPoint)
        
        let normalTransform = CGAffineTransform(a: 1.0, b: 0, c: 0, d: 1.0, tx: 0, ty: 0)
        
        return (animating: animatingTransform, picking: pickingTransform, normal: normalTransform)
    }
    
    /** タブをアニメーションとともに選択状態にする */
    open func select() {
        let transforms = createLabelTransform()
        bringTabViewToFront()
        
        guard label.transform.a == 1.0 && label.transform.d == 1.0 else { return }
        UIView.animate(withDuration: AnimationDuration.long.rawValue, animations: { [weak self] () -> Void in
            self?.label.transform = transforms.animating
            }, completion: { [weak self] (finished) -> Void in
                guard !(self?.label.transform.a == 1.0 && self?.label.transform.d == 1.0) else { return }
                UIView.animate(withDuration: AnimationDuration.short.rawValue, animations: { [weak self]() -> Void in
                    self?.label.transform = transforms.picking
                    })
            })
    }
    
    /** タブを非選択状態にする */
    open func deselect(animated: Bool = true) {
        let transforms = createLabelTransform()
        if animated == false {
            label.transform = transforms.normal
        } else {
            UIView.animate(withDuration: AnimationDuration.long.rawValue, animations: { [weak self] () -> Void in
                self?.label.transform = transforms.normal
                })
        }
    }
    
    /** タブを一時的に選択状態にする */
    open func highlight(sec: Double = 0.3) {
        let transforms = createLabelTransform()
        bringTabViewToFront()
        
        UIView.animate(withDuration: AnimationDuration.long.rawValue, animations: { [weak self] () -> Void in
            self?.label.transform = transforms.picking
            }, completion: { (finished) -> Void in
                DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
                    UIView.animate(withDuration: AnimationDuration.long.rawValue, animations: { [weak self] () -> Void in
                        self?.label.transform = transforms.normal
                    })
                }
        })
    }
    
    /** タブを最前面に移動する */
    open func bringTabViewToFront() {
        dependentSlider?.baseView.bringSubviewToFront(self)
    }
    
}

