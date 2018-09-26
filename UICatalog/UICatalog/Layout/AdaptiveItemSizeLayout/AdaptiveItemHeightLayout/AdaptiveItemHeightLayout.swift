//
//  AdaptiveItemHeightLayout.swift
//  AdaptiveItemHeightLayout
//
//  Created by 横山 拓也 on 2016/03/30.
//  Copyright © 2016年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemHeightLayout: AdaptiveItemSizeLayout {
    public init(configuration: AdaptiveItemHeightLayout.Configuration? = nil) {
        super.init(container: ColumnContainer(configuration: configuration))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
