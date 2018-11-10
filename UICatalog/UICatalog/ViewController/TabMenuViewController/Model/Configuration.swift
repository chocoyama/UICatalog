//
//  Configuration.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/20.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

public struct TabMenuConfiguration {
    // MARK: Appearance
    public var menuViewHeight: CGFloat = 50
    public var menuViewInset: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
    public var menuItemSpacing: CGFloat = 5.0
    
    // MARK: Setting
    public var shouldShowMenuSettingItem: Bool = false
    public var settingIcon = SettingIcon()
    
    // MARK: Add
    public var shouldShowAddButton: Bool = false
    public var addIcon = AddIcon()
    
    // MARK: Action
    public var longPressBehavior: LongPressBehavior = .none
    
    public init() {}
}

extension TabMenuConfiguration {
    public enum LongPressBehavior {
        case none
        case presentMenu
    }
}

protocol IconConfiguration {
    var image: UIImage { get }
    var backgroundColor: UIColor { get set }
    var reductionRate: Double  { get set }
}

extension TabMenuConfiguration {
    
    public struct SettingIcon: IconConfiguration {
        public enum Color {
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
        
        public var color: Color = .black
        public var backgroundColor: UIColor = .lightGray
        public var reductionRate: Double = 1.0
        
        public var image: UIImage { return color.image }
    }
    
    public struct AddIcon: IconConfiguration {
        public enum Color {
            case black
            case white
            
            internal var image: UIImage {
                let imageName: String
                switch self {
                case .black: imageName = "plus_black"
                case .white: imageName = "plus_white"
                }
                return UIImage(named: imageName, in: .current, compatibleWith: nil)!
            }
        }
        
        public var color: Color = .black
        public var backgroundColor: UIColor = .lightGray
        public var reductionRate: Double = 1.0
        
        public var image: UIImage { return color.image }
    }
}
