//
//  FirestoreCompatible.swift
//  Vote
//
//  Created by Takuya Yokoyama on 2018/05/01.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import Foundation

public protocol FirestoreCompatible {
    init?(data: [String: Any])
    func toFirestoreData() -> [String: Any]
}
