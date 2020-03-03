//
//  Post5ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/27.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class Post5ViewController: UIViewController{
    
    // 受付開始日
    @IBOutlet weak var startDay: UIDatePicker!
    // 終了日
    @IBOutlet weak var lastDay: UIDatePicker!
    
    // 受け入れ開始日
    var SYear:Int = 0
    var SMonth:Int = 0
    var Sday:Int = 0
    // 受け入れ終了日
    var LYear:Int = 0
    var LMonth:Int = 0
    var LDay:Int = 0
    
    // datapickerで選択されたものが送られる
    var selectedfirstDay:String! = ""
    var selectedLastDay:String! = ""
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectStartDay(_ sender: Any) {
        // 今日の日付をとってくる
        let now = Date()
        // 一年後の同じ日の日付
        let aYearLater = Date(timeIntervalSinceNow: 60 * 60 * 8760)
        // 最小　最大の選べる日数
        startDay.minimumDate = now
        startDay.maximumDate = aYearLater
        
        //　startdateの次の日がlastdayのminimumDateになる
        lastDay.minimumDate = Date(timeInterval: 60 * 60 * 24, since: startDay.date)
    }
    
    // 受け入れ最終日
    @IBAction func slectLastDay(_ sender: Any) {
        // startDayから30日後までしか選ばせなくする?
        let lastdayMaximum = Date(timeInterval: 60 * 60 * 720, since: lastDay.date)
        // 最大で選べる日数
        lastDay.maximumDate = lastdayMaximum
    }
    
    // next
    @IBAction func next(_ sender: Any) {
        
        // 日にちが重なっていた場合は先にいかせない
        if startDay.date == lastDay.date {
            print("日にちが足りません")
            return
            
        } else {
            // インスタンス化
            let formatter = DateFormatter()
            
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
            
            // 変数の中に選択された情報を入れていく
            selectedfirstDay = formatter.string(from: startDay.date)
            selectedLastDay = formatter.string(from: lastDay.date)
            
            // nilでない場合はtrue
            guard selectedfirstDay != nil else{
                print("ここが呼ばれてよ")
                return
            }
            
            // 遷移用
            print(selectedfirstDay!)
            print(selectedLastDay!)
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post6") as! Post6ViewController
            
            // フルスクリーンに
            nextVC.modalPresentationStyle = .fullScreen
            // 遷移する際に情報を渡す
            nextVC.beginAcceptanceDate = formatter.string(from: startDay.date)
            nextVC.finishAcceptanceDate = formatter.string(from: lastDay.date)
            nextVC.userID = userID
            present(nextVC, animated: true, completion: nil)
        }
    }
    
    // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
