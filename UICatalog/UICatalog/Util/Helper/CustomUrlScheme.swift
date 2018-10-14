//
//  CustomUrlScheme.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/15.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import Foundation

/// NOTICE:
/// Apple標準アプリ以外のカスタムURLスキームを使う場合は、
/// Info.plistにLSApplicationQueriesSchemesというキーで利用するスキームの登録をする必要がある
enum CustomUrlScheme {
    case appStore(appid: String)
    case lineText(message: String)
    case lineImage(pasteBoardName: String)
    
    func createUrlScheme() -> URL {
        let urlString: String
        switch self {
        case .appStore(let appid):
            urlString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=\(appid)&mt=8"
        case .lineText(let message):
            let encodedString = message.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            urlString = "line://msg/text/\(encodedString)"
        case .lineImage(let pasteBoardName):
            urlString = "line://msg/image/\(pasteBoardName)"
        }
        return URL(string: urlString)!
    }
}
