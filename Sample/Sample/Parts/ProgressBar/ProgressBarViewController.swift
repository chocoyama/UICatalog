//
//  ProgressBarViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/09/23.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class ProgressBarViewController: UIViewController {

    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var percentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ProgressBar.Configuration(
            leftColor: .cyan,
            rightColor: .white,
            initialPercent: 0.0,
            cornerRadius: 30,
            labelSetting: ("", .black, .systemFont(ofSize: 12.0))
        )
        
        progressBar.configure(with: configuration)
    }
    
    @IBAction func didTappedUpdateButton(_ sender: UIButton) {
        guard let inputText = percentTextField.text,
            let percent = Double(inputText),
            percent >= 0.0 && percent <= 1.0 else {
            return
        }
        
        progressBar.update(
            percent: percent,
            labelTitle: "\(percent)",
            animationSetting: .default,
            completion: nil
        )
    }
}
