 //
//  OverlayMenuView.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class OverlayMenuView: UIView, XibInitializable {
    
    public enum Position {
        case `default`
        case compact
        case overlay
        case none
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundMaskView: UIView!
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    
    private var configuration = Configuration()
    private var position: Position = .default
    
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
        setUp(position: .default)
    }
    
    open func set(configuration: Configuration) {
        self.configuration = configuration
    }
    
    open func setUp(position: Position, animated: Bool = true) {
        let originY: CGFloat
        let alpha: CGFloat
        
        switch position {
        case .default:
            originY = 200
            alpha = 0.2
        case .overlay:
            originY = 40
            alpha = 0.2
        case .compact:
            let compactHeight: CGFloat = 200
            originY = self.bounds.height - compactHeight
            alpha = 0.2
        case .none:
            originY = self.frame.height
            alpha = 0.0
        }
        
        contentViewTopConstraint.constant = originY
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.backgroundMaskView.alpha = alpha
            self.layoutIfNeeded()
        }
    }
}

extension OverlayMenuView {
    private func assignGestures() {
        backgroundMaskView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTappedMaskView(_:)))
        )
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTappedContentView(_:)))
        )
    }
    
    @objc private func didTappedMaskView(_ sender: UITapGestureRecognizer) {
        setUp(position: .compact)
    }
    
    @objc private func didTappedContentView(_ sender: UITapGestureRecognizer) {
        setUp(position: .overlay)
    }
}

 extension OverlayMenuView {
    public struct Configuration {
        struct Position
        typealias PositionValue = (height: CGFloat, alpha: CGFloat)
        
        let
    }
 }
