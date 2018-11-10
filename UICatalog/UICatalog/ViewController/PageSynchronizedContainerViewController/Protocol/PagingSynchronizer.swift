//
//  PagingSynchronizer.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/14.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol PagingSynchronizer: class {
    func pagingSynchronizer(didChangedPageAt index: Int, section: Int, observer: PagingChangeObserver)
    func pagingSynchronizer(changePageExcept observer: PagingChangeObserver, index: Int, section: Int)
    func pagingSynchronizer(changePageOnly observer: PagingChangeObserver, index: Int, section: Int)
}

extension PagingSynchronizer where Self: UIViewController {
    public func pagingSynchronizer(didChangedPageAt index: Int, section: Int, observer: PagingChangeObserver) {
        children.compactMap { $0 as? PagingChangeSubscriber }
                .forEach { (subscriber) in
                    DispatchQueue.main.async {
                        subscriber.synchronize(pageIndex: index, section: section, observer: observer)
                    }
                }
    }
    
    public func pagingSynchronizer(changePageExcept observer: PagingChangeObserver, index: Int, section: Int) {
        children.compactMap { $0 as? PagingChangeSubscriber }
            .forEach { (subscriber) in
                if !subscriber.isEqual(observer) {
                    DispatchQueue.main.async {
                        subscriber.synchronize(pageIndex: index, section: section, observer: observer)
                    }
                }
        }
    }
    
    public func pagingSynchronizer(changePageOnly observer: PagingChangeObserver, index: Int, section: Int) {
        children.compactMap { $0 as? PagingChangeSubscriber }
            .forEach { (subscriber) in
                if subscriber.isEqual(observer) {
                    DispatchQueue.main.async {
                        subscriber.synchronize(pageIndex: index, section: section, observer: observer)
                    }
                }
        }
    }
}
