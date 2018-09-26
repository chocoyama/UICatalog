//
//  ViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2017/02/18.
//  Copyright © 2017年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class RangeSliderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = RangeSlider()
        let configuration = RangeSlider.Configuration(
            frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 65),
            values: [0, 100, 200, 300, 400, 500, 600, 700, 900, 1000],
            tabPosition: (left: 200, right: 700),
            activeColor: .blue,
            deactiveColor: .lightGray
        )
        slider.configure(with: configuration)
        slider.delegate = self
        view.addSubview(slider)
    }

}

extension RangeSliderViewController: RangeSliderDelegate {
    func didStartedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider) {
        print("Start: \(range)")
    }
    
    func didChangedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider) {
        print("Change: \(range)")
    }
    
    func didFinishedSlide(range: RangeSlider.RangeValue, atRangeSlider: RangeSlider) {
        print("Finish: \(range)")
    }
    
}
