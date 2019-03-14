//
//  Configuration.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/11/07.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

extension SemiModalView {
    public struct Configuration {
        public var customView: UIView?
        public var position: SemiModalView.Position = .relative(.init())
        public var enablePresentingViewInteraction: Bool = false
        public var enableAutoRelocation: Bool = false
        
        public init() {}
    }
}
