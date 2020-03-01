//
//  Post4ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/24.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class Post4ViewController: UIViewController {
    
    // ボタンのイメージ
    let image0:UIImage! = UIImage(named: "丸")
    let image1:UIImage! = UIImage(named: "チェック")
    
    // ボタン
    @IBOutlet weak var necessitiesButton: UIButton!
    @IBOutlet weak var wifiButton: UIButton!
    @IBOutlet weak var kitchenButton: UIButton!
    @IBOutlet weak var heatingButton: UIButton!
    @IBOutlet weak var airconditioningButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var washingMachineButton: UIButton!
    @IBOutlet weak var dryerMachineButton: UIButton!
    
    // カウント
    var count1 = 0
    var count2 = 0
    var count3 = 0
    var count4 = 0
    var count5 = 0
    var count6 = 0
    var count7 = 0
    var count8 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // buttonのタグ
    enum selectButtonTag:Int {
        
        case action1 = 1
        case action2 = 2
        case action3 = 3
        case action4 = 4
        case action5 = 5
        case action6 = 6
        case action7 = 7
        case action8 = 8
    }
    
    // ボタンを押した時条件分岐４
    @IBAction func userselectedButton(_ sender: Any) {
        if let button = sender as? UIButton {
            if let tag = selectButtonTag(rawValue: button.tag) {
                switch tag {
                case .action1:
                    // ゼロの時は
                    if count1 == 1 {
                        //丸を入れる
                        necessitiesButton.setImage(image0, for: .normal)
                        count1 = 0
                        print("!!!")
                        print(count1)
                        // カウントがゼロの時は押されたら
                    } else {
                        necessitiesButton.setImage(image1, for: .normal)
                        count1 = 1
                        print(count1)
                    }
                    // 以下同じ
                case .action2:
                    if count2 == 1 {
                    wifiButton.setImage(image0, for: .normal)
                    count2 = 0
                    } else{
                        wifiButton.setImage(image1, for: .normal)
                        count2 = 1
                    }
                case .action3:
                    if count3 == 1{
                    kitchenButton.setImage(image0, for: .normal)
                        count3 = 0
                    }else{
                    kitchenButton.setImage(image1, for: .normal)
                    count3 = 1
                    }
                case .action4:
                    if count4 == 1 {
                    heatingButton.setImage(image0, for: .normal)
                        count4 = 0
                    }else {
                        heatingButton.setImage(image1, for: .normal)
                        count4 = 1
                    }
                case .action5:
                    if count5 == 1 {
                    airconditioningButton.setImage(image0, for: .normal)
                    count5 = 0
                    }else {
                        airconditioningButton.setImage(image1, for: .normal)
                        count5 = 1
                    }
                case .action6:
                    if count6 == 1 {
                    tvButton.setImage(image0, for: .normal)
                        count6 = 0
                    } else {
                        tvButton.setImage(image1, for: .normal)
                        count6 = 1
                    }
                case .action7:
                    if  count7 == 1 {
                    washingMachineButton.setImage(image0, for: .normal)
                   count7 = 0
                    } else {
                        washingMachineButton.setImage(image1, for: .normal)
                        count7 = 1
                    }
                case .action8:
                    if count8 == 1 {
                    dryerMachineButton.setImage(image0, for: .normal)
                        count8 = 0
                    }else{
                        dryerMachineButton.setImage(image1, for: .normal)
                        count8 = 1
                    }
                }
            }
        }
    }
    
    // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Next
    @IBAction func next(_ sender: Any) {
        // count数を保存
        UserDefaults.standard.set(count1, forKey: "count1")
        UserDefaults.standard.set(count2, forKey: "count2")
        UserDefaults.standard.set(count3, forKey: "count3")
        UserDefaults.standard.set(count4, forKey: "count4")
        UserDefaults.standard.set(count5, forKey: "count5")
        UserDefaults.standard.set(count6, forKey: "count6")
        UserDefaults.standard.set(count7, forKey: "count7")
        UserDefaults.standard.set(count8, forKey: "count8")
        
        // 遷移
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post5") as! Post5ViewController
        // fullscreanに
        nextVC.modalPresentationStyle = .fullScreen
        
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    
    

}
