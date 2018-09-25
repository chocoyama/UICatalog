//
//  CellHeightCalculatable.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol CellHeightCalculatable {
    associatedtype Model
    static var cellForCalcHeight: Self? { get set }
    func configure(for model: Model)
}

extension CellHeightCalculatable where Self: UICollectionViewCell {
    static public func height(for model: Model, width: CGFloat, owner: Any) -> CGFloat {
        if cellForCalcHeight == nil {
            cellForCalcHeight = instantiateFromNib(owner: owner)
        }
        cellForCalcHeight?.configure(for: model)
        cellForCalcHeight?.frame.size.width = width
        cellForCalcHeight?.setNeedsLayout()
        cellForCalcHeight?.layoutIfNeeded()
        let height = cellForCalcHeight?.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height ?? 0.0
    }
}

