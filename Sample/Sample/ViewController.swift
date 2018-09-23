//
//  ViewController.swift
//  Sample
//
//  Created by Takuya Yokoyama on 2018/09/19.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit
import UICatalog

class ViewController: UIViewController {

    enum Row: String {
        case rangeSlider = "RangeSlider"
        case progressBar = "ProgressBar"
        
        var sampleViewController: UIViewController {
            switch self {
            case .rangeSlider: return RangeSliderViewController.instantiate(storyboardName: "RangeSlider")
            case .progressBar: return ProgressBarViewController()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let rows: [Row] = [
        .rangeSlider,
        .progressBar
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = rows[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sampleViewController = rows[indexPath.row].sampleViewController
        navigationController?.pushViewController(sampleViewController, animated: true)
    }
}
