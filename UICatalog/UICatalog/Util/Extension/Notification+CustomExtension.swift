//
//  Notification+CustomExtension.swift
//  MiseryPot
//
//  Created by Takuya Yokoyama on 2018/01/13.
//  Copyright © 2018年 chocoyama. All rights reserved.
//

import UIKit

extension Notification {
    var keyboardFrame: CGRect? {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var keyboardAnimateDuration: TimeInterval? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
    }
}
