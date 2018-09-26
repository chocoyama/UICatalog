//
//  AdaptiveItemWidthLayoutConfiguration.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/09/25.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

extension AdaptiveItemWidthLayout {
    public struct Configuration {
        public var minimumInterItemSpacing: CGFloat
        public var minimumLineSpacing: CGFloat
        public var sectionInsets: UIEdgeInsets
        
        public init(
            minimumInterItemSpacing: CGFloat = 5.0,
            minimumLineSpacing: CGFloat = 10.0,
            sectionInsets: UIEdgeInsets = .zero
        ) {
            self.minimumInterItemSpacing = minimumInterItemSpacing
            self.minimumLineSpacing = minimumLineSpacing
            self.sectionInsets = sectionInsets
        }
    }
}
