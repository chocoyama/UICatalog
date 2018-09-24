//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Takuya Yokoyama on 2018/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol RangeSliderDelegate: class {
    func didStartedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider)
    
    /// スライダーの値が変化する度に呼ばれる
    func didChangedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider)
    
    /// スライダーから指を離したタイミングで呼ばれる
    func didFinishedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider)
}

open class RangeSlider: UIView, RangeSliderViewInitializable {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var rangeSliderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightMarginConstraint: NSLayoutConstraint!
    
    // MARK:- RangeBar
    @IBOutlet weak var mainRangeBar: UIView!
    @IBOutlet weak var leftRangeBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightRangeBarWidthConstraint: NSLayoutConstraint!
    let leftRangeBarDefaultWidth: CGFloat = 0.0
    let rightRangeBarDefaultWidth: CGFloat = 0.0
    @IBOutlet weak var leftRangeBar: UIView!
    @IBOutlet weak var rightRangeBar: UIView!
    
    // MARK:- Tab
    @IBOutlet weak var leftTab: RangeSliderTab! {
        didSet { leftTab.initialize(type: .left, dependentSlider: self) }
    }
    @IBOutlet weak var rightTab: RangeSliderTab! {
        didSet { rightTab.initialize(type: .right, dependentSlider: self) }
    }
    @IBOutlet weak var leftTabHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTabRightAlignmentConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftTabBottomAlignmentConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTabHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTabLeftAlignmentConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTabBottomAlignmentConstraint: NSLayoutConstraint!
    
    // MARK:- IntermediateLabel
    @IBOutlet weak var leftIntermediateLabel: UILabel!
    @IBOutlet weak var rightIntermediateLabel: UILabel!
    @IBOutlet weak var leftIntermediateSeparaterLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightIntermediateSeparaterLeftConstraint: NSLayoutConstraint!

    private(set) var rangeValue = SliderValue()
    private var pickingState: PickingState = .noPicking
    
    public typealias RangeValue = (minimumValue: Int, maximumValue: Int)
    
    enum Position {
        case left
        case right
    }
    var latestPickingPosition: Position = .left
    
    open weak var delegate: RangeSliderDelegate?
    
    private var config = Configuration() {
        didSet {
            self.frame = config.frame
            self.rangeValue = SliderValue(values: config.values)
            rangeSliderHeightConstraint.constant = config.frame.height
            [mainRangeBar, leftTab.label, rightTab.label].forEach{ $0?.backgroundColor = config.activeColor }
            [leftRangeBar, rightRangeBar].forEach{ $0?.backgroundColor = config.deactiveColor }
            [leftTab.label, rightTab.label].forEach{ $0?.textColor = config.tabTextColor }
            [leftIntermediateLabel, rightIntermediateLabel].forEach{ $0?.textColor = config.intermediateTextColor }
            setNeedsLayout()
            layoutIfNeeded() // 表示しているコントローラーが最前面にない場合レイアウトが崩れるので必要な処理
            updateLabel()
            updateIntermediateSeparator()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
        initDefaultValues()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
        initDefaultValues()
    }
    
    // MARK:- Initialize
    /** 設定を元に初期化する（アニメーションなし） */
    open func configure(with configuration: Configuration) {
        self.config = configuration
        updateTabPosition(animated: false)
    }
    
    /** 設定を元に更新する（アニメーションあり） */
    open func update(with configuration: Configuration) {
        self.config = configuration
        updateTabPosition(animated: true)
    }
    
    open var currentValue: RangeValue {
        return (leftTab.value, rightTab.value)
    }
    
    /** 初期値を設定する */
    private func initDefaultValues() {
        self.frame = config.frame
        rangeSliderHeightConstraint.constant = config.frame.height
        leftRangeBarWidthConstraint.constant = leftRangeBarDefaultWidth
        rightRangeBarWidthConstraint.constant = rightRangeBarDefaultWidth
        leftTabHeightConstraint.constant = leftTab.allHeight
        rightTabHeightConstraint.constant = rightTab.allHeight
        
        let horizontalConstantForAdjust = -(leftTab.tab.frame.width / 2)
        let verticalConstantForAdjust = (leftTab.tab.frame.height / 2) - (mainRangeBar.frame.height / 2) - leftTab.tabBorderWidth
        leftTabRightAlignmentConstraint.constant = horizontalConstantForAdjust
        leftTabBottomAlignmentConstraint.constant = verticalConstantForAdjust
        rightTabLeftAlignmentConstraint.constant = horizontalConstantForAdjust
        rightTabBottomAlignmentConstraint.constant = verticalConstantForAdjust
        
        layoutIfNeeded()
    }
    
    // MARK:- UserAction
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        noticeStarted()
        
        let touchStartPoint = touches.first?.location(in: self) ?? CGPoint.zero
        let state = pickingState.changeState(slider: self, touchStartPoint: touchStartPoint)
        switch state {
        case .leftPicking:
            leftTab.select()
            latestPickingPosition = .left
        case .rightPicking:
            rightTab.select()
            latestPickingPosition = .right
        case .noPicking:
            let mainCenterPosition = mainRangeBar.frame.minX + (mainRangeBar.frame.width / 2)
            let targetTab: RangeSliderTab
            if mainCenterPosition >= touchStartPoint.x {
                targetTab = leftTab
                latestPickingPosition = .left
            } else {
                targetTab = rightTab
                latestPickingPosition = .right
            }
            
            targetTab.moveAtPoint(pointX: touchStartPoint.x)
            UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
                self?.layoutIfNeeded()
            }, completion: { [weak self] (finished) -> Void in
                guard let weakSelf = self else { return }
                targetTab.highlight()
                weakSelf.noticeFinish()
            })
        }
    }
    
    @IBAction func viewDidSwiped(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let state = pickingState.changeState(slider: self, touchStartPoint: sender.location(in: self))
            switch state {
            case .leftPicking: leftTab.select()
            case .rightPicking: rightTab.select()
            case .noPicking: break
            }
            fallthrough
        case .changed:
            let translationPoint = sender.translation(in: self)
            guard pickingState.isAvailableTabMove(slider: self, translationPoint: translationPoint) else {
                sender.setTranslation(CGPoint.zero, in: self)
                break
            }
            switch pickingState {
            case .leftPicking: leftTab.move(translationPointX: translationPoint.x)
            case .rightPicking: rightTab.move(translationPointX: -translationPoint.x)
            case .noPicking: break
            }
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            switch pickingState {
            case .leftPicking: leftTab.deselect()
            case .rightPicking: rightTab.deselect()
            case .noPicking:
                leftTab.deselect(animated: false)
                rightTab.deselect(animated: false)
            }
            pickingState = .noPicking
            updateLabel()
            noticeFinish()
        default: break
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickingState = .noPicking
        leftTab.deselect(animated: false)
        rightTab.deselect(animated: false)
    }
    
    // MARK:- Delegation
    /** レンジの変更をデリゲート先に通知する */
    func noticeStarted() {
        delegate?.didStartedSlide(range: (leftTab.value, rightTab.value), atRangeSlider: self)
    }
    
    func noticeChanged() {
        delegate?.didChangedSlide(range: (leftTab.value, rightTab.value), atRangeSlider: self)
    }
    
    func noticeFinish() {
        delegate?.didFinishedSlide(range: (leftTab.value, rightTab.value), atRangeSlider: self)
    }
    
    // MARK:- UpdateView
    /** タブの表示位置を更新する */
    private func updateTabPosition(animated: Bool) {
        let leftValue = config.tabPosition.left.map{$0} ?? rangeValue.minValue
        let rightValue = config.tabPosition.right.map{$0} ?? rangeValue.maxValue
        
        guard !(leftTab.value == leftValue && rightTab.value == rightValue) else { return }
        
        leftTab.moveAtValue(value: leftValue)
        rightTab.moveAtValue(value: rightValue)

        leftTab.forceUpdateLabel(price: leftValue)
        rightTab.forceUpdateLabel(price: rightValue)
        
        leftTab.bringSubviewToFront(baseView)
        rightTab.bringSubviewToFront(baseView)
        
        guard animated == true else { return }
        UIView.animate(withDuration: 0.3) { [weak self] () -> Void in
            self?.layoutIfNeeded()
        }
    }
    
    /** 左右両方のタブのラベルを更新する */
    private func updateLabel() {
        leftTab.label.text = leftTab.text
        rightTab.label.text = rightTab.text
    }
    
    /** 中間値の表示値と表示位置を更新する */
    private func updateIntermediateSeparator() {
        guard let intermediateValue = rangeValue.intermediateValue else { return }
        leftIntermediateLabel.text = "\(intermediateValue.left)"
        rightIntermediateLabel.text = "\(intermediateValue.right)"
        let leftIntermediateSeparatorPositionX = dynamicPositionX(value: intermediateValue.left)
        let rightIntermediateSeparatorPositionX = dynamicPositionX(value: intermediateValue.right)
        leftIntermediateSeparaterLeftConstraint.constant = leftIntermediateSeparatorPositionX
        rightIntermediateSeparaterLeftConstraint.constant = rightIntermediateSeparatorPositionX
    }
    
    //MARK:- DynamicValue
    /** ラベルの表示を切り替えるタイミングの増分値を返す */
    var dx: CGFloat {
        let mainBarDefaultMaxX = rightRangeBar.frame.maxX - rightRangeBarDefaultWidth
        let mainBarDefaultMinX = leftRangeBar.frame.minX + leftRangeBarDefaultWidth
        return (mainBarDefaultMaxX - mainBarDefaultMinX) / CGFloat(rangeValue.values.count - 1)
    }
    
    /** 座標に対応する表示値を返す */
    func dynamicValue(locationX: CGFloat) -> Int? {
        let x = locationX - (leftMarginConstraint.constant + leftRangeBarDefaultWidth) + (dx / 2)
        for (index, value) in rangeValue.values.enumerated() {
            if dx * CGFloat(index) <= x && x < dx * CGFloat(index + 1) {
                return value
            }
        }
        return nil
    }
    
    /** 引数の値に切り替わるタイミングのX座標を返す */
    func dynamicPositionX(value: Int) -> CGFloat {
        let mainBarDefaultMinX = leftRangeBar.frame.minX + leftRangeBarDefaultWidth
        var positionX: CGFloat = mainBarDefaultMinX
        if let index = rangeValue.indexFromValue(value: value) {
            positionX += dx * CGFloat(index)
        }
        return positionX
    }
    
}
