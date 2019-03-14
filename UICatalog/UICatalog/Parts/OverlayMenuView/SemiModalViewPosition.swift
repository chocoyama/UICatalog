//
//  Position.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/07.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension SemiModalView {
    public struct Position {
        public struct Value {
            let coverRate: CGFloat
            let maskViewAlpha: CGFloat
            
            public init(coverRate: CGFloat, maskViewAlpha: CGFloat) {
                self.coverRate = coverRate
                self.maskViewAlpha = maskViewAlpha
            }
            
            public func calculateOriginY(from bounds: CGRect, parentView: UIView?) -> CGFloat {
                let safeAreaTop: CGFloat = parentView?.safeAreaInsets.top ?? 0.0
                let safeAreaBottom: CGFloat = parentView?.safeAreaInsets.bottom ?? 0.0
                let height = bounds.height + safeAreaTop + safeAreaBottom
                return height - (height * coverRate)
            }
        }
        
        public let compact: Value
        public let middle: Value
        public let overlay: Value
        public let none: Value = .init(coverRate: 0.0, maskViewAlpha: 0.0)
        
        public let minimumValue: Value
        public let maximumValue: Value
        
        public init(
            compact: Value = .init(coverRate: 0.2, maskViewAlpha: 0.2),
            middle: Value = .init(coverRate: 0.4, maskViewAlpha: 0.2),
            overlay: Value = .init(coverRate: 0.95, maskViewAlpha: 0.2),
            minimumValue: Value? = nil,
            maximumValue: Value? = nil
        ) {
            self.compact = compact
            self.middle = middle
            self.overlay = overlay
            self.minimumValue = minimumValue ?? compact
            self.maximumValue = maximumValue ?? overlay
        }
    }
}
