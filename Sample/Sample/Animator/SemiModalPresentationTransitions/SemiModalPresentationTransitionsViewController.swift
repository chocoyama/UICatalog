//
//  SemiModalPresentationTransitionsViewController.swift
//  Sample
//
//  Created by 横山 拓也 on 2019/05/07.
//  Copyright © 2019 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class SemiModalPresentationTransitionsViewController: UIViewController {
    
    private var semiModalTransitioningDelegate: SemiModalPresentationTransitions?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTappedButton(_ sender: UIButton) {
        let viewController = UIViewController()
        semiModalTransitioningDelegate = SemiModalPresentationTransitions(viewController: viewController,
                                                                          animation: .system)
        
        viewController.view.backgroundColor = .blue
        viewController.view.frame = CGRect(x: 0,
                                           y: 0,
                                           width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height / 2)
        viewController.transitioningDelegate = semiModalTransitioningDelegate
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: nil)
    }
    
}
