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

    enum Row: String, CaseIterable {
        case rangeSlider = "RangeSlider"
        case progressBar = "ProgressBar"
        case outlineLabel = "OutlineLabel"
        case adaptiveItemHeightLayout = "AdaptiveItemHeightLayout"
        case adaptiveItemWidthLayout = "AdaptiveItemWidthLayout"
        case soundWaveButton = "SoundWaveButton"
        case infiniteLoopPageViewController = "InfiniteLoopPageViewController"
        case pageSynchronizedContainerViewController = "PageSynchronizedContainerViewController"
        case tabMenuViewController = "TabMenuViewController"
        case rotationImageView = "RotationImageView"
        case zoomTransitionAnimator = "ZoomTransitionAnimator"
        case semiModalRelativeView = "SemiModalRelativeView"
        case semiModalAbsoluteView = "SemiModalAbsoluteView"
        
        var sampleViewController: UIViewController {
            switch self {
            case .rangeSlider: return RangeSliderViewController.instantiate(storyboardName: "RangeSlider")
            case .progressBar: return ProgressBarViewController()
            case .outlineLabel: return OutlineLabelViewController()
            case .adaptiveItemHeightLayout: return AdaptiveItemHeightLayoutViewController.instantiate(storyboardName: "AdaptiveItemHeightLayoutViewController")
            case .adaptiveItemWidthLayout: return AdaptiveItemWidthLayoutViewController()
            case .soundWaveButton: return SoundWaveButtonViewController()
            case .infiniteLoopPageViewController: return SampleInfiniteLoopPageViewController()
            case .pageSynchronizedContainerViewController: return SamplePageSynchronizedContainerViewController()
            case .tabMenuViewController:
                var configuration = TabMenuConfiguration()
                configuration.shouldShowMenuSettingItem = true
                configuration.settingIcon.reductionRate = 0.8
                configuration.shouldShowAddButton = true
                configuration.addIcon.reductionRate = 0.8
                configuration.longPressBehavior = .presentMenu
                
                return SampleTabMenuViewController(
                    topMenu: TopMenu(title: "トップ"),
                    sampleMenus: [
                        SampleMenu(title: "Google", url: URL(string: "https://www.google.co.jp/")!),
                        SampleMenu(title: "Twitter", url: URL(string: "https://twitter.com/")!),
                        SampleMenu(title: "Instagram", url: URL(string: "https://www.instagram.com/")!),
                        SampleMenu(title: "Facebook", url: URL(string: "https://www.facebook.com/")!),
                        SampleMenu(title: "Amazon", url: URL(string: "https://www.amazon.co.jp/")!),
                    ],
                    configuration: configuration
                )
            case .rotationImageView: return RotationImageViewController()
            case .zoomTransitionAnimator: return ZoomTransitionAnimatorViewController()
            case .semiModalRelativeView: return SemiModalRelativeViewController()
            case .semiModalAbsoluteView: return SemiModalAbsoluteViewController()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private let rows = Row.allCases

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
