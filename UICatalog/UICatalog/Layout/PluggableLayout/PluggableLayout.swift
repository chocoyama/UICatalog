//
//  PluggableLayout.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/10/11.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class PluggableLayout: AdaptiveItemSizeLayout {
    public struct Item {
        let size: CGSize
    }
    
    open func plug(item: Item, before indexPath: IndexPath) {
        
    }
    
    open func plug(item: Item, after indexPath: IndexPath) {
        
    }
}

public protocol PluggableLayoutDelegate: class {
    func pluggableLayout(_ layout: PluggableLayout, sizeForItemAt indexPath: IndexPath) -> PluggableLayout.Item
    func pluggableLayout(_ layout: PluggableLayout, referenceSizeForHeaderIn section: Int) -> PluggableLayout.Item
}

extension PluggableLayoutDelegate {
    public func pluggableLayout(_ layout: PluggableLayout, referenceSizeForHeaderIn section: Int) -> PluggableLayout.Item {
        return PluggableLayout.Item(size: .zero)
    }
}
