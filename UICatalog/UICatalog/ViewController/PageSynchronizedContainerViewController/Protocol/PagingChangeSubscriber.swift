//
//  PagingChangeSubscriber.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol PagingChangeSubscriber {
    var pagingSynchronizer: PagingSynchronizer? { get set }
    func synchronize(pageIndex index: Int)
}
