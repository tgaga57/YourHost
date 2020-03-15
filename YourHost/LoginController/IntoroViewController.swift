//
//  ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Lottie

class IntoroViewController: UIViewController,UIScrollViewDelegate{
    
    var startPoint:CGFloat!
    
    var jsonImageArray = ["1","2","3"]
    
    var introStringArray = ["旅先で宿泊費無料??","世界中のホストがあなたを待っています","気になるホストに連絡してみよう"]
    
    // スクロールView
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // pageスクロールを可能に
        scrollView.isScrollEnabled = true
        
        scrollView.showsVerticalScrollIndicator = false
        // スクロールによるintroStringArrayの表示
        setScroll()
        
        for i in 0...2{
            // インスタンス化
            let animationView = AnimationView()
            // アニメーションにjsonimageArrayのi番目を入れていく
            let animation = Animation.named(jsonImageArray[i])
            // フレームを決めていく
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: -60, width: view.frame.size.width, height: view.frame.size.height)
            
            animationView.animation = animation
            // ScaleAspectFitに
            animationView.contentMode = .scaleAspectFit
            // animatioをループ
            animationView.loopMode = .loop
            // アニメーションのスピード
            animationView.animationSpeed = 0.85
            // animationをplay
            animationView.play()
            // addsubview
            scrollView.addSubview(animationView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationcontrollerを消した
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setScroll() {
        
        scrollView.delegate = self
        
        // コンテントサイズ
        // 今回スクロールビューは３個ある
        scrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: scrollView.frame.size.height)
        
        for i in 0...2 {
            //　画面のサイズに合わせてサイズを変更
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height / 3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            // メニュー単位のスクロール
            scrollView.isPagingEnabled = true
            // フォントサイズ
            onboardLabel.font = .boldSystemFont(ofSize: 21.0)
            // テキストアライメント、センターに
            onboardLabel.textAlignment = .center
            
            // テキストカラー
            onboardLabel.textColor = .systemPink
            // テキストに[i] 番目を入れる
            onboardLabel.text = introStringArray[i]
        
            // scrollViewにaddsubview
            scrollView.addSubview(onboardLabel)
        }
    }

}

