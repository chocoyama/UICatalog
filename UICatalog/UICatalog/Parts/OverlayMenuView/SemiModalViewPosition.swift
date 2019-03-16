//
//  Position.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/07.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol PositionValue {
    var maskViewAlpha: CGFloat { get }
    func calculateOriginY(from bounds: CGRect) -> CGFloat
}

extension SemiModalView {
    public enum Position {
        case absolute(AbsolutePosition)
        case relative(RelativePosition)
    }
    
    public struct AbsolutePosition {
        public struct Value: PositionValue {
            let height: CGFloat
            public let maskViewAlpha: CGFloat
            
            public init(height: CGFloat, maskViewAlpha: CGFloat) {
                self.height = height
                self.maskViewAlpha = maskViewAlpha
            }
            
            public func calculateOriginY(from bounds: CGRect) -> CGFloat {
                return bounds.height - self.height
            }
        }
        public let max: Value
        public let min: Value
        public let none: Value = .init(height: 0.0, maskViewAlpha: 0.0)
        
        public init(max: Value, min: Value) {
            self.max = max
            self.min = min
        }
    }
    
    public struct RelativePosition {
        public struct Value: PositionValue {
            let coverRate: CGFloat
            public let maskViewAlpha: CGFloat
            
            public init(coverRate: CGFloat, maskViewAlpha: CGFloat) {
                self.coverRate = coverRate
                self.maskViewAlpha = maskViewAlpha
            }
            
            public func calculateOriginY(from bounds: CGRect) -> CGFloat {
                return bounds.height - (bounds.height * coverRate)
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
