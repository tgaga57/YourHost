//
//  animation.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/03.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Indicator: ViewController {
    
    // インジゲーターの変数
    var activityIndicatorView: NVActivityIndicatorView!
    // ロード時画面のview
    var indicatorBackgroundView: UIView!
    
    func indicatorDesign(){
        // インジゲーターのサイズ
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
        // インジゲーターをセンターへ
        activityIndicatorView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
    }
    
    func startAnimation() {
        // スタートアニメーション
        activityIndicatorView.color = .green
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimation() {
        // ストップアニメーション
        activityIndicatorView.color = .green
        activityIndicatorView.stopAnimating()
    }
    
    
}
