//
//  ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController,UIScrollViewDelegate{
    
    var startPoint:CGFloat!
    
    var jsonImageArray = ["1","2","3"]
    
    var introStringArray = ["旅先ボランティアでホストの家に宿泊","新しい旅の形を","気になるホストに連絡してみよう"]
    
    // スクロールView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // pageスクロールを可能に
        scrollView.isScrollEnabled = true
        // スクロールによるintroStringArrayの表示
        setScroll()
        
        for i in 0...2{
            // インスタンス化
            let animationView = AnimationView()
            // アニメーションにjsonimageArrayのi番目を入れていく
            let animation = Animation.named(jsonImageArray[i])
            // フレームを決めていく
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            
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
            
            // フォントサイズ
            onboardLabel.font = .boldSystemFont(ofSize: 22.0)
            // センターに
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

