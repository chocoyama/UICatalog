//
//  ProgressBar.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/23.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

@IBDesignable
open class ProgressBar: UIView, XibInitializable {
    
    public struct Configuration {
        let leftColor: UIColor
        let rightColor: UIColor
        let initialPercent: Double
        
        public init(leftColor: UIColor, rightColor: UIColor = .white, initialPercent: Double = 0.0) {
            self.leftColor = leftColor
            self.rightColor = rightColor
            self.initialPercent = initialPercent
        }
    }
    
    public struct AnimationSetting {
        let duration: TimeInterval
        let shouldSpringAnimation: Bool
        
        public static let `default` = AnimationSetting(
            duration: 0.3,
            shouldSpringAnimation: true
        )
    }

    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var noColorView: UIView!
    @IBOutlet weak var coloredViewWidthConstraint: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
    
    @discardableResult
    open func configure(with configuration: Configuration) -> Self {
        coloredView.backgroundColor = configuration.leftColor
        noColorView.backgroundColor = configuration.rightColor
        coloredViewWidthConstraint.constant = toValue(from: configuration.initialPercent)
        return self
    }
    
    open func update(percent: Double, animationSetting: AnimationSetting?) {
        coloredViewWidthConstraint.constant = toValue(from: percent)
        
        if let setting = animationSetting {
            if setting.shouldSpringAnimation {
                UIView.animate(
                    withDuration: 0.7,
                    delay: setting.duration,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.0,
                    options: [],
                    animations: {
                        self.layoutIfNeeded()
                    },
                    completion: nil
                )
            } else {
                UIView.animate(withDuration: setting.duration) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func toValue(from percent: Double) -> CGFloat {
        return self.frame.width * CGFloat(percent)
    }
    
}
