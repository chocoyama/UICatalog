//
//  RotationImageViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2018/10/26.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class RotationImageViewController: UIViewController {

    @IBOutlet weak var rotationImageView: RotationImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotationImageView.resources = [
            .image(UIImage(named: "cat")!),
            .image(UIImage(named: "flower")!),
            .image(UIImage(named: "sky")!)
        ]
        rotationImageView.interval = 7.0
        rotationImageView.animation = .zoomFadeOut(scale: 1.4)
        rotationImageView.setup()
        rotationImageView.startRotation()
    }

}
