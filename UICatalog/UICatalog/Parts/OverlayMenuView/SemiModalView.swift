 //
//  OverlayMenuView.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
 
 public protocol SemiModalViewDelegate: class {
    func semiModalView(_ semiModalView: SemiModalView, didTappedNonModalArea point: CGPoint)
 }
 
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
    
    open weak var delegate: SemiModalViewDelegate?
    
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
        
        let isHidden = contentViewTopConstraint.constant >= noneConstraint
        if isHidden {
            return nil
        }
        
        if !configuration.enablePresentingViewInteraction {
            return tappedView
        }
        
        if contentView.frame.contains(point) {
            return tappedView
        } else {
            delegate?.semiModalView(self, didTappedNonModalArea: point)
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
    
    open func show(from fromValue: PositionValue, to toValue: PositionValue) {
        self.isHidden = false
        updatePosition(to: fromValue, animated: false)
        updatePosition(to: toValue, animated: true)
    }
    
    open func updatePosition(to value: PositionValue, animated: Bool = true) {
        let nextY = value.calculateOriginY(from: self.bounds)
        contentViewTopConstraint.constant = nextY
        customViewBottomConstraint?.constant = nextY - customViewTotalTopMargin
        UIView.animate(
            withDuration: animated ? 0.7 : 0.0,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.2,
            options: [],
            animations: {
                self.backgroundMaskView.alpha = value.maskViewAlpha
                self.layoutIfNeeded()
            },
            completion: { finished in
            }
        )
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
        switch configuration.position {
        case .absolute(let absolutePosition):
            updatePosition(to: absolutePosition.max, animated: false)
        case .relative(let relativePosition):
            updatePosition(to: relativePosition.overlay, animated: false)
        }
        
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
        switch configuration.position {
        case .absolute(let absolutePosition):
            updatePosition(to: absolutePosition.min)
        case .relative(let relativePosition):
            updatePosition(to: relativePosition.compact)
        }
    }
    
    @objc private func didTappedContentView(_ sender: UITapGestureRecognizer) {
        switch configuration.position {
        case .absolute(let absolutePosition):
            updatePosition(to: absolutePosition.max)
        case .relative(let relativePosition):
            updatePosition(to: relativePosition.overlay)
        }
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
    
    private var minConstant: CGFloat {
        switch configuration.position {
        case .absolute(let absolutePosition):
            return absolutePosition.max.calculateOriginY(from: self.bounds)
        case .relative(let relativePosition):
            return relativePosition.maximumValue.calculateOriginY(from: self.bounds)
        }
    }
    
    private var maxConstant: CGFloat {
        switch configuration.position {
        case .absolute(let absolutePosition):
            return absolutePosition.min.calculateOriginY(from: self.bounds)
        case .relative(let relativePosition):
            return relativePosition.minimumValue.calculateOriginY(from: self.bounds)
        }
    }
    
    private var noneConstraint: CGFloat {
        switch configuration.position {
        case .absolute(let absolutePosition):
            return absolutePosition.none.calculateOriginY(from: self.bounds)
        case .relative(let relativePosition):
            return relativePosition.none.calculateOriginY(from: self.bounds)
        }
    }
    
    private var maxAlpha: CGFloat? {
        switch configuration.position {
        case .absolute(let absolutePosition):
            return absolutePosition.max.maskViewAlpha
        case .relative(_):
            return nil
        }
    }
    
    private func moveInteractive(translationY: CGFloat) {
        let nextConstant = contentViewTopConstraint.constant + translationY
        
        let shouldMoveMenu = 0 < nextConstant && nextConstant <= maxConstant
        if shouldMoveMenu {
            contentViewTopConstraint.constant = nextConstant
            customViewBottomConstraint?.constant = nextConstant
            
            if let maxAlpha = maxAlpha {
                let maxHeight = maxConstant - minConstant
                let currentHeight = maxConstant - nextConstant
                backgroundMaskView.alpha = maxAlpha * (currentHeight / maxHeight)
            }
        }
    }
    
    private func relocateIfNeeded() {
        guard configuration.enableAutoRelocation else { return }
        
        switch configuration.position {
        case .absolute(let absolutePosition):
            let max = absolutePosition.max.calculateOriginY(from: self.bounds)
            let min = absolutePosition.min.calculateOriginY(from: self.bounds)
            let maxPlusHalf = min - ((min - max) / 2)

            switch contentViewTopConstraint.constant {
            case 0..<max:
                updatePosition(to: absolutePosition.max)
            case max..<maxPlusHalf:
                updatePosition(to: absolutePosition.max)
            case maxPlusHalf..<min:
                updatePosition(to: absolutePosition.min)
            default:
                break
            }
            
        case .relative(let relativePosition):
            let overlay = relativePosition.overlay.calculateOriginY(from: self.bounds)
            let middle = relativePosition.middle.calculateOriginY(from: self.bounds)
            let compact = relativePosition.compact.calculateOriginY(from: self.bounds)
            let middlePlusHalf = compact - ((compact - middle) / 2)
            let overlayPlusHalf = middle - ((middle - overlay) / 2)
            
            switch contentViewTopConstraint.constant {
            case 0..<overlay:
                updatePosition(to: relativePosition.overlay, animated: true)
            case overlay..<overlayPlusHalf:
                updatePosition(to: relativePosition.overlay, animated: true)
            case overlayPlusHalf..<middle:
                updatePosition(to: relativePosition.middle, animated: true)
            case middle..<middlePlusHalf:
                updatePosition(to: relativePosition.middle, animated: true)
            case middlePlusHalf..<compact:
                updatePosition(to: relativePosition.compact, animated: true)
            default:
                break
            }
        }
    }
}

