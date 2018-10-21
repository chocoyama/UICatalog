//
//  Bundle+.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class DummyClass {}
        return Bundle(for: type(of: DummyClass()))
    }
}
