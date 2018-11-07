 //
//  OverlayMenuView.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
 
open class OverlayMenuView: UIView, XibInitializable {

    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.rounded(cornerRadius: 15.0,
                                cornerMasks: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
        }
    }
    @IBOutlet weak var backgroundMaskView: UIView!
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    
    private let position = Position()
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
        assignGestures()
        update(position: position.default)
    }
    
    open func set(configuration: Configuration) {
        self.configuration = configuration
    }
    
//    open func setUp(to parentView: UIView) {
//        self.overlay(on: parentView)
//    }

    open func update(position value: Position.Value, animated: Bool = true) {
        contentViewTopConstraint.constant = value.calculateOriginY(from: self.bounds)
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.backgroundMaskView.alpha = value.alpha
            self.layoutIfNeeded()
        }
    }
}

extension OverlayMenuView {
    private func assignGestures() {
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(didSwipedView(_:))))
        backgroundMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                       action: #selector(didTappedMaskView(_:))))
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                action: #selector(didTappedContentView(_:))))
    }
    
    @objc private func didTappedMaskView(_ sender: UITapGestureRecognizer) {
        update(position: position.compact)
    }
    
    @objc private func didTappedContentView(_ sender: UITapGestureRecognizer) {
        update(position: position.overlay)
    }
    
    @objc private func didSwipedView(_ sender: UIPanGestureRecognizer) {
        let nextConstant = contentViewTopConstraint.constant + sender.translation(in: self).y
        
        let minConstant: CGFloat = 0
        let maxConstant: CGFloat = position.compact.calculateOriginY(from: self.bounds)
        let shouldMoveMenu = minConstant < nextConstant && nextConstant <= maxConstant
        
        if shouldMoveMenu {
            contentViewTopConstraint.constant = nextConstant
        }
        
        sender.setTranslation(.zero, in: self)
    }
}

