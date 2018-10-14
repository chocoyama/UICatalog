//
//  LineMessenger.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

open class LineMessenger {
    private let lineAppid = "443904275"
    
    open func sendMessage(message: String) {
        let lineUrl = CustomUrlScheme.lineText(message: message).createUrlScheme()
        openUrl(url: lineUrl, appid: lineAppid)
    }
    
    open func sendImage(image: UIImage) {
        guard let pngData = image.pngData() else { return }
        let pasteBoard = UIPasteboard.general
        pasteBoard.setData(pngData, forPasteboardType: "public.png")
        let lineUrl = CustomUrlScheme.lineImage(pasteBoardName: pasteBoard.name.rawValue).createUrlScheme()
        openUrl(url: lineUrl, appid: lineAppid)
    }
    
    /** appidが指定されていた場合、urlでアプリを開けなかったときにappidを利用してAppStoreに飛ばす*/
    private func openUrl(url: URL, appid: String?) {
        guard UIApplication.shared.canOpenURL(url) else {
            if let appid = appid {
                let appStoreUrl = CustomUrlScheme.appStore(appid: appid).createUrlScheme()
                if UIApplication.shared.canOpenURL(appStoreUrl) {
                    UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                }
            }
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}
