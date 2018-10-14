//
//  PagingSynchronizer.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol PagingSynchronizer: class {
    func pagingSynchronizer(subscriber: PagingChangeSubscriber?, didChangedPageAt index: Int, section: Int)
}
extension PagingSynchronizer where Self: UIViewController {
    public func pagingSynchronizer(subscriber: PagingChangeSubscriber?, didChangedPageAt index: Int, section: Int) {
        children
            .compactMap { $0 as? PagingChangeSubscriber }
            .forEach { (subscriber) in
                DispatchQueue.main.async {
                    subscriber.synchronize(pageIndex: index, section: section)
                }
        }
    }
}
