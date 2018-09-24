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
        public typealias LabelSetting = (String, UIColor, UIFont)
        
        let leftColor: UIColor
        let rightColor: UIColor
        let initialPercent: Double
        let cornerRadius: CGFloat?
        let labelSetting: LabelSetting?
        
        public init(
            leftColor: UIColor,
            rightColor: UIColor = .white,
            initialPercent: Double = 0.0,
            cornerRadius: CGFloat? = nil,
            labelSetting: LabelSetting? = nil
        ) {
            self.leftColor = leftColor
            self.rightColor = rightColor
            self.initialPercent = initialPercent
            self.cornerRadius = cornerRadius
            self.labelSetting = labelSetting
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
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var percentLabelLeftConstraint: NSLayoutConstraint!
    
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
        
        if let cornerRadius = configuration.cornerRadius {
            coloredView.round(cornerRadius: cornerRadius, cornerMasks: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        }
        
        if let (title, color, font) = configuration.labelSetting {
            percentLabel.text = title
            percentLabel.textColor = color
            percentLabel.font = font
            percentLabel.isHidden = false
        } else {
            percentLabel.text = ""
            percentLabel.isHidden = true
        }
        
        return self
    }
    
    open func update(percent: Double, labelTitle: String?, animationSetting: AnimationSetting?) {
        self.percentLabel.alpha = 0.0
        self.percentLabel.text = labelTitle
        self.percentLabel.setNeedsLayout()
        self.percentLabel.layoutIfNeeded()
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
                        self.percentLabel.alpha = 1.0
                        self.layoutIfNeeded()
                    },
                    completion: { _ in
                    }
                )
            } else {
                UIView.animate(withDuration: setting.duration) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private func toValue(from percent: Double) -> CGFloat {
        let margin: CGFloat
        if self.percentLabel.isHidden {
            margin = 0.0
        } else {
            margin = self.percentLabel.frame.width + (percentLabelLeftConstraint.constant * 2)
        }
        return (self.frame.width - margin) * CGFloat(percent)
    }
    
}
