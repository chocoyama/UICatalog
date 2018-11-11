//
//  Page.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol Page {
    var id: String { get set }
    var title: String { get set }
    var pinned: Bool { get set }
}

