//
//  Configuration.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/20.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public struct TabMenuConfiguration {
    public var shouldShowMenuSettingItem: Bool = false
    public var shouldShowAddButton: Bool = false
    public var longPressBehavior: LongPressBehavior = .none
    
    public var menuViewHeight: CGFloat = 50
    public var menuViewInset: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
    public var menuItemSpacing: CGFloat = 5.0
    
    public var settingIcon = SettingIcon()
    
    public init() {}
}

extension TabMenuConfiguration {
    public enum LongPressBehavior {
        case none
        case delete
        case presentMenu
    }
}

extension TabMenuConfiguration {
    public struct SettingIcon {
        public enum MenuColor {
            case black
            case white
            
            internal var image: UIImage {
                let imageName: String
                switch self {
                case .black: imageName = "menu_black"
                case .white: imageName = "menu_white"
                }
                return UIImage(named: imageName, in: .current, compatibleWith: nil)!
            }
        }
        
        public var menuColor: MenuColor = .black
        public var backgroundColor: UIColor = .lightGray
        public var reductionRate: Double = 1.0
    }
}
