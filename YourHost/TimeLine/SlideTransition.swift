//
//  SlideTransition.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class SlideTransition: NSObject,UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    // タイムインターバル
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let containerView = transitionContext.containerView
        // 横幅
        let finalWidth = toViewController.view.bounds.width * 0.8
        // 縦幅
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // コンテイナーにメニューviewを追加
            containerView.addSubview(toViewController.view)
            // 画面の初期化
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
            
        }
        // アニメーション 
        let transform = {
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y:0)
        }
        // アニメーションバック
        let identity = {
            fromViewController.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform():identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    
    
}
