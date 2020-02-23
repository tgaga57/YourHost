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
    var numberOfGuestCount = 0
    // ゲスト寝室用
    var numberOfGuestBedroomCount = 0
    // ゲストのベッドの数
    var numberOfGuestBedCount = 0
    
    let button:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    numberOfGuestCount >= 0
                    numberOfGuestCount -= 1
                    numberOfGuestsLabel.text = String(numberOfGuestCount)
                    if numberOfGuestBedroomCount == 0{
                        guestMinusButton.isEnabled = false
                    }
                    // ゲストの数プラス
                case .action1:
                    numberOfGuestCount += 1
                    numberOfGuestsLabel.text = String(numberOfGuestCount)
                    // ゲストの寝室マイナス
                case .action2:
                    numberOfGuestBedroomCount -= 1
                    forGuestsBedroomLabel.text = String(numberOfGuestBedroomCount)
                    // ゲストの寝室プラス
                case .action3:
                    numberOfGuestBedroomCount += 1
                    forGuestsBedroomLabel.text = String(numberOfGuestBedroomCount)
                    // ゲスト利用可能ベッドマイナス
                case .action4:
                    numberOfGuestBedCount -= 1
                    forGuestsBedLabel.text = String(numberOfGuestBedCount)
                    // ゲスト利用可能ベッドプラス
                case .action5:
                    numberOfGuestBedCount += 1
                    forGuestsBedLabel.text = String(numberOfGuestBedCount)
                default:
                    break
                }
            }
        }
    }

    
    // 戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
