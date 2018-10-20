//
//  Page.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol Page {
    associatedtype Entity
    var number: Int { get }
    var title: String { get set }
    var entity: Entity { get set }
}

extension Page {
    public func typeErased() -> AnyPage<Entity> {
        return AnyPage(page: self)
    }
}

open class AnyPage<Entity>: Page {
    public var number: Int
    open var title: String
    open var entity: Entity
    
    required public init<T: Page>(page: T) where T.Entity == Entity {
        self.number = page.number
        self.title = page.title
        self.entity = page.entity
    }
}
