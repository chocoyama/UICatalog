import UIKit

enum PickingState {
    case leftPicking
    case rightPicking
    case noPicking
    
    /** タッチが開始された座標から状態を決定して返す */
    mutating func changeState(slider: RangeSlider, touchStartPoint: CGPoint) -> PickingState {
        let rightTouchAvailable = slider.rightTab.touchAvailableFrame.contains(touchStartPoint)
        let leftTouchAvailable = slider.leftTab.touchAvailableFrame.contains(touchStartPoint)
        
        if rightTouchAvailable && leftTouchAvailable {
            let checkViews: [UIView] = [slider.leftTab, slider.leftTab.tab, slider.leftTab.label, slider.leftTab.labelBaseView]
            if let hitView = slider.hitTest(touchStartPoint, with: nil), checkViews.contains(hitView) {
                changeToLeftPicking()
            } else {
                changeToRightPicking()
            }
        } else if rightTouchAvailable {
            changeToRightPicking()
        } else if leftTouchAvailable {
            changeToLeftPicking()
        } else {
            self = .noPicking
        }
        
        return self
    }
    
    func isAvailableTabMove(slider: RangeSlider, translationPoint: CGPoint) -> Bool {
        switch self {
        case .leftPicking:
            let x = slider.leftMarginConstraint.constant + slider.leftRangeBarWidthConstraint.constant + translationPoint.x
            return (x <= slider.leftTab.dynamicMaxPoint) && (slider.leftRangeBarWidthConstraint.constant + translationPoint.x >= slider.leftRangeBarDefaultWidth)
        case .rightPicking:
            let x = slider.frame.width - (slider.rightMarginConstraint.constant + slider.rightRangeBarWidthConstraint.constant - translationPoint.x)
            return (x >= slider.rightTab.dynamicMaxPoint) && (slider.rightRangeBarWidthConstraint.constant - translationPoint.x >= slider.rightRangeBarDefaultWidth)
        case .noPicking: return true
        }
    }
    
    private mutating func changeToLeftPicking() {
        guard self != .rightPicking else { return }
        self = .leftPicking
    }
    
    private mutating func changeToRightPicking() {
        guard self != .leftPicking else { return }
        self = .rightPicking
    }
    
}
