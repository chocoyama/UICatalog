//
//  Position.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/07.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension OverlayMenuView {
    public struct Position {
        public struct Value {
            let coverRate: CGFloat
            let alpha: CGFloat
            
            public func calculateOriginY(from parentBounds: CGRect) -> CGFloat {
                return parentBounds.height - (parentBounds.height * coverRate)
            }
        }
        
        public let `default`: Value
        public let compact: Value
        public let overlay: Value
        public let none: Value
        
        init(
            default: Value = .init(coverRate: 0.3, alpha: 0.2),
            compact: Value = .init(coverRate: 0.1, alpha: 0.2),
            overlay: Value = .init(coverRate: 0.95, alpha: 0.2),
            none: Value = .init(coverRate: 0.0, alpha: 0.0)
            ) {
            self.default = `default`
            self.compact = compact
            self.overlay = overlay
            self.none = none
        }
    }
}
