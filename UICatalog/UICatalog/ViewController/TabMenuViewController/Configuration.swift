//
//  Configuration.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/20.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension TabMenuViewController {
    public struct Configuration {
        public enum LongPressBehavior {
            case none
            case delete
            case presentMenu
        }
        
        public var shouldShowMenuSettingItem: Bool = false
        public var shouldShowAddButton: Bool = false
        public var longPressBehavior: LongPressBehavior = .none
        
        public var menuViewHeight: CGFloat = 50
        public var menuViewInset: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
        public var menuItemSpacing: CGFloat = 5.0
        
        public init() {}
    }
}
