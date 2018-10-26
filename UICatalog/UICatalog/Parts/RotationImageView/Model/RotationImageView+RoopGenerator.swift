//
//  RotationImageView+RoopGenerator.swift
//  IntervalZoomImageView
//
//  Created by takyokoy on 2017/06/30.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import Foundation

extension RotationImageView {
    
    class RoopGenerator<T> {
        typealias Element = T
        
        private(set) var elements: [Element]
        private var index = 0
        
        init(elements: [T]) {
            self.elements = elements
        }
        
        func append(_ elements: [Element]) {
            self.elements.append(contentsOf: elements)
        }
        
        func next() -> Element? {
            if elements.isEmpty {
                return nil
            }
            
            if index >= elements.count {
                index = 0
            }
            
            let element = elements[index]
            index += 1
            
            return element
        }
    }

}
