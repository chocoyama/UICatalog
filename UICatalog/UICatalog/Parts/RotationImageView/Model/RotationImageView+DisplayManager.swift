//
//  RotationImageView+DisplayManager.swift
//  IntervalZoomImageView
//
//  Created by takyokoy on 2017/06/30.
//  Copyright © 2017年 takyokoy. All rights reserved.
//

import Foundation

extension RotationImageView {
    
    class DisplayManager {
        
        struct Element {
            let item: RotationImageItem
            var state: State?
            
            init(item: RotationImageItem, state: State?) {
                self.item = item
                self.state = state
            }
            
            func nextState() -> Element? {
                guard let nextState = self.state?.next else { return nil }
                return Element(item: self.item, state: nextState)
            }
        }
        
        enum State {
            case active
            case ready
            case loaded
            
            static var sequence: [State] {
                return [.active, .ready, .loaded]
            }
            
            var next: State {
                switch self {
                case .active: return .loaded
                case .ready:  return .active
                case .loaded: return .ready
                }
            }
        }
        
        fileprivate var elements: [Element] = []
        fileprivate let generator: RoopGenerator<PhotoResource>
        
        init(resources: [PhotoResource]) {
            self.elements = (0..<State.sequence.count).map{ _ in Element(item: .init(), state: nil) }
            self.generator = RoopGenerator(elements: resources)
        }
        
    }
    
}

// MARK:- Getter
extension RotationImageView.DisplayManager {
    
    var activeItem: RotationImageItem {
        return elements.filter{ $0.state == .active }.first!.item
    }
    
    var readyItem: RotationImageItem {
        return elements.filter{ $0.state == .ready }.first!.item
    }
    
    var inactiveItems: [RotationImageItem] {
        return elements.filter{ $0.state != .active }.map{ $0.item }
    }
    
}

// MARK:- Internal Method
extension RotationImageView.DisplayManager {
    
    func setup() -> [RotationImageItem] {
        let stateSequence = State.sequence
        
        let resources = (0..<stateSequence.count).compactMap{ _ in generator.next() }
        guard resources.count == stateSequence.count && elements.count == stateSequence.count else {
            return []
        }
        
        stateSequence.enumerated().forEach {
            resources[$0.offset].load(to: elements[$0.offset].item)
            elements[$0.offset].state = $0.element
        }
        
        return elements.map{ $0.item }
    }
    
    func loadNext() {
        guard let resource = generator.next() else { return }
        resource.load(to: activeItem)
        elements = elements.compactMap { $0.nextState() }
    }
    
    func append(_ resources: [PhotoResource]) {
        self.generator.append(resources)
    }
    
}
