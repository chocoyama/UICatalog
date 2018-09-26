//
//  AdaptiveItemWidthLayout.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class AdaptiveItemWidthLayout: AdaptiveItemSizeLayout {
    public init(configuration: AdaptiveItemWidthLayout.Configuration? = nil) {
        super.init(container: RowContainer(configuration: configuration))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
