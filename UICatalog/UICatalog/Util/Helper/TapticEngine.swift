//
//  TapticEngine.swift
//  MiseryPot
//
//  Created by takyokoy on 2017/12/26.
//  Copyright © 2017年 chocoyama. All rights reserved.
//

import UIKit

/// **Usage**
///
/// ・単発の触覚フィードバックを動作させる
/// ```
/// TapticEngine.playHaptic(for: .favorite)
/// ```
/// ・連続でHapticを発生させるような場合は、プロパティなどにインスタンスを保持させておき、それを使い回すようにする
/// ```
/// class SomeClass {
///     let tapticEngine = TapticEngine.prepare(for: .rangeSlider)
///
///     func someContinuousAction() {
///         self.tapticEngine?.playHaptic()
///     }
/// }
/// ```
public struct TapticEngine {
    
    /// 新規でHapticを発生させる要因ができた場合は、基本ここをいじるだけでOK
    public enum Feedback {
        case buttonTap
        
        fileprivate var hapticType: TapticEngine.HapticType {
            switch self {
            case .buttonTap:    return .impact(style: .heavy)
            }
        }
    }
    
    /// iOS9をサポートしていてもTapticEngineのインスタンスをプロパティに保持しておけるようにAny型で定義している
    fileprivate let feedbackGenerator: Any?
    fileprivate let hapticType: HapticType?
    
}


// MARK:- static func
extension TapticEngine {
    
    /// TapticEngineを初期化して返す
    ///
    /// - Parameter feedback: Feedbackの種類を指定する
    /// - Returns: TapticEngineのインスタンス
    public static func prepare(for feedback: Feedback) -> TapticEngine? {
        guard #available(iOS 10.0, *) else { return nil }
        let hapticType = feedback.hapticType
        let generator = hapticType.generator
        generator.prepare()
        return TapticEngine(feedbackGenerator: generator, hapticType: hapticType)
    }
    
    /// 単発のHapticを発生させる
    ///
    /// - Parameter feedback: 発生させるFeedbackの種類
    public static func playHaptic(for feedback: Feedback) {
        TapticEngine.prepare(for: feedback)?.playHaptic()
    }
    
}


// MARK:- internal func
extension TapticEngine {
    
    /// Hapticを発生させる準備をする。
    /// 前回のprepareから時間が経過してしまっている場合など、明示的に呼び出す必要がある場合に利用する。
    @discardableResult
    public func prepare() -> TapticEngine? {
        guard #available(iOS 10.0, *) else { return nil }
        (feedbackGenerator as? UINotificationFeedbackGenerator)?.prepare()
        return self
    }
    
    /// Hapticを発生させる。
    /// TapticEngineを生成してから時間が経っている場合などにはprepare()を明示的に呼び出してから実行すると安全。
    public func playHaptic() {
        guard let hapticType = self.hapticType, #available(iOS 10.0, *) else { return }
        switch hapticType {
        case .notification(let type):
            let generator = (feedbackGenerator as? UINotificationFeedbackGenerator)
            generator?.notificationOccurred(type)
            generator?.prepare()
        case .impact(_):
            let generator = (feedbackGenerator as? UIImpactFeedbackGenerator)
            generator?.impactOccurred()
            generator?.prepare()
        case .selection:
            let generator = (feedbackGenerator as? UISelectionFeedbackGenerator)
            generator?.selectionChanged()
            generator?.prepare()
        }
    }
    
}


// MARK:- fileprivate
extension TapticEngine {
    
    fileprivate enum HapticType {
        case notification(type: UINotificationFeedbackGenerator.FeedbackType)
        case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
        case selection
        
        @available(iOS 10.0, *)
        var generator: UIFeedbackGenerator {
            switch self {
            case .notification(_):   return UINotificationFeedbackGenerator()
            case .impact(let style): return UIImpactFeedbackGenerator(style: style)
            case .selection:         return UISelectionFeedbackGenerator()
            }
        }
    }
    
}


