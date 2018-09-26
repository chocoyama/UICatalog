//
//  SoundWaveButton.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/25.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

class SoundWaveButton: UIView, XibInitializable {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
}
