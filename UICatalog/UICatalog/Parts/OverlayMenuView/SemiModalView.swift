 //
//  OverlayMenuView.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
 
open class SemiModalView: UIView, XibInitializable {

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView
                .rounded(cornerRadius: 15.0,
                         cornerMasks: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
                         masksToBounds: false)
                .addDropShadow(offsetSize: CGSize(width: 0.0, height: -1.0),
                               opacity: 0.1,
                               radius: 2.0,
                               color: .black)
        }
    }
    @IBOutlet weak var backgroundMaskView: UIView!
    @IBOutlet weak var knobView: UIView!
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    private var customViewBottomConstraint: NSLayoutConstraint?
    private var customViewTotalTopMargin: CGFloat = .leastNormalMagnitude
    
    private var configuration = Configuration()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let tappedView = super.hitTest(point, with: event)
        
        if !configuration.enablePresentingViewInteraction {
            return tappedView
        }
        
        if contentView.frame.contains(point) {
            return tappedView
        } else {
            updatePosition(to: configuration.position.compact)
            return nil
        }
    }
}

// MARK: Public
 extension SemiModalView {
    open func setUp(with configuration: Configuration) {
        self.configuration = configuration
        configureSubviews(by: configuration)
        assignGestures(by: configuration)
    }
    
    open func show(from fromValue: Position.Value, to toValue: Position.Value) {
        self.isHidden = false
        updatePosition(to: fromValue, animated: false)
        updatePosition(to: toValue, animated: true)
    }
    
    open func updatePosition(to value: Position.Value, animated: Bool = true) {
        let nextY = value.calculateOriginY(from: self.bounds, parentView: superview)
        contentViewTopConstraint.constant = nextY
        customViewBottomConstraint?.constant = nextY - customViewTotalTopMargin
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.backgroundMaskView.alpha = value.maskViewAlpha
            self.layoutIfNeeded()
        }
    }
 }
 
 // MARK: Private
 extension SemiModalView {
    private func configureSubviews(by configuration: Configuration) {
        if configuration.enablePresentingViewInteraction {
            backgroundMaskView.isHidden = true
        } else {
            backgroundMaskView.isHidden = false
        }
        
        if let customView = configuration.customView {
            set(customView)
        }
    }
    
    private func set(_ customView: UIView) {
        updatePosition(to: configuration.position.overlay, animated: false)
        
        let topMargin: CGFloat = 8.0
        customViewTotalTopMargin = frame.origin.y + knobView.frame.maxY + topMargin - 1
        
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: knobView.bottomAnchor, constant: topMargin).isActive = true
        customView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        customViewBottomConstraint = customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -customViewTotalTopMargin)
        customViewBottomConstraint?.isActive = true
    }
 }
 
// MARK: Action
extension SemiModalView {
    private func assignGestures(by configuration: Configuration) {
        if configuration.enablePresentingViewInteraction {
            contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                    action: #selector(didSwipedView(_:))))
            contentView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(didTappedContentView(_:))))
        } else {
            self.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                             action: #selector(didSwipedView(_:))))
            backgroundMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                           action: #selector(didTappedMaskView(_:))))
            contentView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(didTappedContentView(_:))))
        }
    }
    
    @objc private func didTappedMaskView(_ sender: UITapGestureRecognizer) {
        updatePosition(to: configuration.position.compact)
    }
    
    @objc private func didTappedContentView(_ sender: UITapGestureRecognizer) {
        updatePosition(to: configuration.position.overlay)
    }
    
    @objc private func didSwipedView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .possible, .began, .changed:
            moveInteractive(translationY: sender.translation(in: self).y)
        case .ended, .cancelled:
            relocateIfNeeded()
        case .failed:
            break
        }
        
        sender.setTranslation(.zero, in: self)
    }
    
    private func moveInteractive(translationY: CGFloat) {
        let nextConstant = contentViewTopConstraint.constant + translationY
        
        let minConstant: CGFloat = configuration.position.maximumValue.calculateOriginY(from: self.bounds, parentView: superview)
        let maxConstant: CGFloat = configuration.position.minimumValue.calculateOriginY(from: self.bounds, parentView: superview)
        let shouldMoveMenu = minConstant < nextConstant && nextConstant <= maxConstant
        
        if shouldMoveMenu {
            contentViewTopConstraint.constant = nextConstant
            customViewBottomConstraint?.constant = nextConstant - customViewTotalTopMargin
        }
    }
    
    private func relocateIfNeeded() {
        guard configuration.enableAutoRelocation else { return }
        let position = configuration.position
        
        let overlay = position.overlay.calculateOriginY(from: self.bounds, parentView: superview)
        let middle = position.middle.calculateOriginY(from: self.bounds, parentView: superview)
        let compact = position.compact.calculateOriginY(from: self.bounds, parentView: superview)
        let middlePlusHalf = compact - ((compact - middle) / 2)
        let overlayPlusHalf = middle - ((middle - overlay) / 2)
        
        switch contentViewTopConstraint.constant {
        case overlay..<overlayPlusHalf:
            updatePosition(to: position.overlay, animated: true)
        case overlayPlusHalf..<middle:
            updatePosition(to: position.middle, animated: true)
        case middle..<middlePlusHalf:
            updatePosition(to: position.middle, animated: true)
        case middlePlusHalf..<compact:
            updatePosition(to: position.compact, animated: true)
        default:
            break
        }
    }
}

