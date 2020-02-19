//
//  Indicator.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/18.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Indicator: UIViewController{
    
    // ロード時画面のview
    var indicatorBackgroundView: UIView!
    // indicatorの変数
    var activityIndicatorView: NVActivityIndicatorView!
    // 新規登録を押された時のインディケーター
    func showLodeIndicator() {
        indicatorBackgroundView = UIView(frame: self.view.bounds)
        indicatorBackgroundView.backgroundColor = .systemPink
        indicatorBackgroundView.alpha = 0.4
        indicatorBackgroundView.tag = 1
        // インジケータと背景を接続
        self.view.addSubview(indicatorBackgroundView)
        indicatorBackgroundView?.addSubview(activityIndicatorView)
        //
        //        //起動
        activityIndicatorView.startAnimating()
    }
    
    // インジケータを非表示にする
    func stopLoadIndicator() {
        // インジケータを消すか判断
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        // 消えます
        activityIndicatorView.stopAnimating()
    }
}
