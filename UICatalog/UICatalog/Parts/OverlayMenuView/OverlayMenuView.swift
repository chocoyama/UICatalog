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
        update(position: position.default)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let tappedView = super.hitTest(point, with: event)
        
        if !configuration.enablePresentingViewInteraction {
            return tappedView
        }
        
        if contentView.frame.contains(point) {
            return tappedView
        } else {
            update(position: position.compact)
            return nil
        }
    }
    
    open func setUp(with configuration: Configuration) {
        self.configuration = configuration
        configureSubviews(by: configuration)
        assignGestures(by: configuration)
    }
    
    open func update(position value: Position.Value, animated: Bool = true) {
        let nextY = value.calculateOriginY(from: self.bounds)
        contentViewTopConstraint.constant = nextY
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.backgroundMaskView.alpha = value.alpha
            self.layoutIfNeeded()
        }
    }
    
    private func configureSubviews(by configuration: Configuration) {
        if configuration.enablePresentingViewInteraction {
            backgroundMaskView.isHidden = true
        } else {
            backgroundMaskView.isHidden = false
        }
        
        if let customView = configuration.customView {
            contentView.insertSubview(customView, at: 0)
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.topAnchor.constraint(equalTo: knobView.bottomAnchor, constant: 8.0).isActive = true
            customView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            customView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
}

// MARK: Action
extension OverlayMenuView {
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
        update(position: position.compact)
    }
    
    @objc private func didTappedContentView(_ sender: UITapGestureRecognizer) {
        update(position: position.overlay)
    }
    
    @objc private func didSwipedView(_ sender: UIPanGestureRecognizer) {
        let nextConstant = contentViewTopConstraint.constant + sender.translation(in: self).y
        
        let minConstant: CGFloat = position.overlay.calculateOriginY(from: self.bounds)
        let maxConstant: CGFloat = position.compact.calculateOriginY(from: self.bounds)
        let shouldMoveMenu = minConstant < nextConstant && nextConstant <= maxConstant
        
        if shouldMoveMenu {
            contentViewTopConstraint.constant = nextConstant
        }
        
        sender.setTranslation(.zero, in: self)
    }
}

