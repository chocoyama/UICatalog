//
//  Pageable.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol Pageable: class {
    var page: Int? { get set } // zero origin
}
