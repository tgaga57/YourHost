//
//  Post2ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/22.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class Post2ViewController: UIViewController{
    
    // ゲストの定員
    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    // ゲスト用の寝室
    @IBOutlet weak var forGuestsBedroomLabel: UILabel!
    // ゲスト用のベッド
    @IBOutlet weak var forGuestsBedLabel: UILabel!
    // ゲストマイナス
    @IBOutlet weak var guestMinusButton: UIButton!
    
    @IBOutlet weak var guestPlusButton: UIButton!
    // ゲストの寝室マイナス
    @IBOutlet weak var guestBedRoomMinusButton: UIButton!
    // ゲストの寝室プラス
    @IBOutlet weak var guestBedRoomPulsButton: UIButton!
    // ゲストのベット数をマイナス
    @IBOutlet weak var guestBedMinusButton: UIButton!
    // ゲストのベット数をプラス
    @IBOutlet weak var guestBedPulsButton: UIButton!
    
    // ゲストの数用
    var numberOfGuestCount:Int = 0
    // ゲスト寝室用
    var numberOfGuestBedroomCount:Int = 0
    // ゲストのベッドの数
    var numberOfGuestBedCount:Int = 0
    
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("post2")
        
        //　ボタンを使わせない設定
        guestMinusButton.isEnabled = false
        guestBedMinusButton.isEnabled = false
        guestBedRoomMinusButton.isEnabled = false
        
        // 情報が来ているか確認
        
    }
    
    enum buttanAction:Int {
        case action0 = 0
        case action1 = 1
        case action2 = 2
        case action3 = 3
        case action4 = 4
        case action5 = 5
    }
    
    // ゲストの定員の数
    // ゲストに提供する寝室の数
    // ゲストに提供するベット数
    @IBAction func selectedGuestNumber(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if let tag = buttanAction(rawValue: button.tag) {
                switch tag {
                // ゲストの数マイナス
                case .action0:
                    numberOfGuestCount -= 1
                    numberOfGuestsLabel.text = "\(numberOfGuestCount)"
                    // ゼロだった場合はマイナスボタンを押せなくしたい
                    if numberOfGuestCount == 0 {
                        guestMinusButton.isEnabled = false
                    }
                // ゲストの数プラス
                case .action1:
                    numberOfGuestCount += 1
                    numberOfGuestsLabel.text = "\(numberOfGuestCount)"
                    // 1以上になったらマイナスボタンを使用可能に
                    if numberOfGuestCount <= 1{
                        guestMinusButton.isEnabled = true
                    }
                // ゲストの寝室マイナス
                case .action2:
                    numberOfGuestBedroomCount -= 1
                    forGuestsBedroomLabel.text = "\(numberOfGuestBedroomCount)"
                    // ゼロだった場合はマイナスボタンを押せなくしたい
                    if numberOfGuestBedroomCount == 0 {
                        guestBedRoomMinusButton.isEnabled = false
                    }
                // ゲストの寝室プラス
                case .action3:
                    numberOfGuestBedroomCount += 1
                    forGuestsBedroomLabel.text = "\(numberOfGuestBedroomCount)"
                    // 1以上ならマイナスボタンを使用可能に
                    if numberOfGuestBedroomCount >= 1{
                        guestBedRoomMinusButton.isEnabled = true
                    }
                // ゲスト利用可能ベッドマイナス
                case .action4:
                    numberOfGuestBedCount -= 1
                    forGuestsBedLabel.text = "\(numberOfGuestBedCount)"
                    // マイナスボタンを使用不可に
                    if numberOfGuestBedCount == 0 {
                        guestBedMinusButton.isEnabled = false
                    }
                // ゲスト利用可能ベッドプラス
                case .action5:
                    numberOfGuestBedCount += 1
                    forGuestsBedLabel.text =  "\(numberOfGuestBedCount)"
                    // マイナスボタンを使用可能に
                    if numberOfGuestBedCount >= 1 {
                        guestBedMinusButton.isEnabled = true
                    }
                default:
                    break
                }
            }
        }
    }
    
    // next
    @IBAction func next(_ sender: Any) {
        // もし一つでも情報が選ばれていなかったら
        if numberOfGuestCount == 0 || numberOfGuestBedroomCount == 0 || numberOfGuestBedCount == 0 {
            print("何も選択されていません")
            // リターンを返す
            return
        } else {
            UserDefaults.standard.set(numberOfGuestCount, forKey: "numberOfGuestCount")
            UserDefaults.standard.set(numberOfGuestBedroomCount, forKey: "numberOfGuestBedroomCount")
            UserDefaults.standard.set(numberOfGuestBedCount, forKey: "numberOfGuestBedCount")
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post3") as! Post3ViewController
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.userID = userID
            self.present(nextVC, animated: true, completion: nil)
        }
         
    }
     
    // 戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
