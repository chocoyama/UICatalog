//
//  PagingChangeObserver.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol PagingChangeObserver {
    var pagingSynchronizer: PagingSynchronizer? { get set }
}

extension PagingChangeObserver {
    public func notifyPageNumberChanged(to page: Int, section: Int) {
        pagingSynchronizer?.pagingSynchronizer(didChangedPageAt: page, section: section)
    }
}
