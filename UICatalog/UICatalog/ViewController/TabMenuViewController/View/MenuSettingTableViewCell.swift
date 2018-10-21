//
//  MenuSettingTableViewCell.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

class MenuSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @discardableResult
    func configure(title: String) -> Self {
        self.label.text = title
        return self
    }
    
}
