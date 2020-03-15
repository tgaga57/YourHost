//
//  MessageRoomViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/13.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class MessageRoomViewController: UIViewController {
    // メッセージから来たのかそれとも投稿情報画面から来たのかを見極めるカウント
    var whrereIsFromCount:Int = 0
    
    var message:Message = Message()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("あなたはどこからきたの\(whrereIsFromCount)")
    }
    
    
    @IBAction func back(_ sender: Any) {
        // タイムラインから直接きた場合
        if whrereIsFromCount == 1 {
            //タイムラインにバック
          self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            print("タイムラインに戻ります")
            //投稿情報から遷移してきた場合
        } else {
            // タイムラインに戻る
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            print("タイムラインに戻ります")
        }
    }
    
    
    
}
