//
//  ProfViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/06.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class ProfViewController: UIViewController,UITextFieldDelegate {

    // view
    @IBOutlet weak var backView: UIView!
    // プロフィール写真
    @IBOutlet weak var pfoImageView: UIImageView!
    // 名前
    @IBOutlet weak var nameTextFiled: UITextField!
    // 年齢
    @IBOutlet weak var ageTextFiled: UITextField!
    // 性別
    @IBOutlet weak var sexSegment: UISegmentedControl!
    // 自己紹介
    @IBOutlet weak var introduceYourSelfTextView: UITextView!
    // プロフィール更新
    @IBOutlet weak var prfofileUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backView.layer.cornerRadius = 25
        pfoImageView.layer.cornerRadius = 50
        
        ageTextFiled.delegate = self
        nameTextFiled.delegate = self
        
        nameTextFiled.addBorderBottom(height: 1, color: .systemPink)
        ageTextFiled.addBorderBottom(height: 1, color: .systemPink)
        
        prfofileUpdate.layer.cornerRadius = 15
    }
    
    // プロフィール写真を変更
    @IBAction func changeImageButton(_ sender: Any) {
    }
    
    // プロフィールアップデート
    @IBAction func profUpdateButton(_ sender: Any) {
    }
    
    
    // リターンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextFiled.resignFirstResponder()
        ageTextFiled.resignFirstResponder()
    introduceYourSelfTextView.resignFirstResponder()
        
        return true
    }
   // 他の部分を触ったらviewを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
