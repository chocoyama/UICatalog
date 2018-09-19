//
//  CellWidthCalculatable.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

protocol CellWidthCalculatable {
    associatedtype Model
    static var cellForCalcWidth: Self? { get set }
    func configure(for model: Model)
}

extension CellWidthCalculatable where Self: UICollectionViewCell {
    static func width(for model: Model, height: CGFloat, owner: Any) -> CGFloat {
        if cellForCalcWidth == nil {
            cellForCalcWidth = instantiateFromNib(owner: owner)
        }
        cellForCalcWidth?.configure(for: model)
        cellForCalcWidth?.frame.size.height = height
        cellForCalcWidth?.setNeedsLayout()
        cellForCalcWidth?.layoutIfNeeded()
        let width = cellForCalcWidth?.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        return width ?? 0.0
    }
}
