//
//  Configuration.swift
//  RangeSlider
//
//  Created by Takuya Yokoyama on 2017/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import Foundation

extension RangeSlider {
    public struct Configuration {
        /**
         Viewのフレームの設定
         */
        let frame: CGRect
        /**
         スライダーに表示する値の設定
         WARNING: 座標を元に表示する値を決定しているので、値が多い場合などはすべて表示できないことがある
         */
        let values: [Int]
        /**
         スライダー上のつまみの初期値の設定
         指定しなければ左端と右端に設定される
         */
        let tabPosition: (left: Int?, right: Int?)
        let activeColor: UIColor
        let deactiveColor: UIColor
        let tabTextColor: UIColor
        let intermediateTextColor: UIColor
        
        public init(
            frame: CGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 65.0),
            values: [Int] = [Int](),
            tabPosition: (left: Int?, right: Int?) = (nil, nil),
            activeColor: UIColor = .blue,
            deactiveColor: UIColor = .lightGray,
            tabTextColor: UIColor = .white,
            intermediateTextColor: UIColor = .black) {
            self.frame = frame
            self.values = values
            self.tabPosition = tabPosition
            self.activeColor = activeColor
            self.deactiveColor = deactiveColor
            self.tabTextColor = tabTextColor
            self.intermediateTextColor = intermediateTextColor
        }
    }
    
}
