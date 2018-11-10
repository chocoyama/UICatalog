//
//  Page.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/19.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol Page: Equatable {
    associatedtype Entity
    var id: String { get set }
    var title: String { get set }
    var entity: Entity { get set }
}

extension Page {
    public func typeErased() -> AnyPage<Entity> {
        return AnyPage(page: self)
    }
}

open class AnyPage<Entity>: Page {
    open var id: String
    open var title: String
    open var entity: Entity
    
    required public init<T: Page>(page: T) where T.Entity == Entity {
        self.id = page.id
        self.title = page.title
        self.entity = page.entity
    }
    
    public static func == (lhs: AnyPage<Entity>, rhs: AnyPage<Entity>) -> Bool {
        return lhs.id == rhs.id
    }
    
}
