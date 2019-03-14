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
            let alpha: CGFloat
            
            public init(coverRate: CGFloat, alpha: CGFloat) {
                self.coverRate = coverRate
                self.alpha = alpha
            }
            
            public func calculateOriginY(from parentBounds: CGRect) -> CGFloat {
                return parentBounds.height - (parentBounds.height * coverRate)
            }
        }
        
        public let initial: Value
        public let compact: Value
        public let middle: Value
        public let overlay: Value
        public let none: Value
        
        public init(
            initial: Value = .init(coverRate: 0.3, alpha: 0.2),
            compact: Value = .init(coverRate: 0.1, alpha: 0.2),
            middle: Value = .init(coverRate: 0.3, alpha: 0.2),
            overlay: Value = .init(coverRate: 0.95, alpha: 0.2),
            none: Value = .init(coverRate: 0.0, alpha: 0.0)
        ) {
            self.initial = initial
            self.compact = compact
            self.middle = middle
            self.overlay = overlay
            self.none = none
        }
    }
}
