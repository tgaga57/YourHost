//
//  NewMemberSettingViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/02.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class NewMemberSettingViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    
    // 名前
    @IBOutlet weak var nameTextField: UITextField!
    // 年
    @IBOutlet weak var ageTextField: UITextField!
    //　自己紹介
    @IBOutlet weak var profTextView: UITextView!
    // email
    @IBOutlet weak var emailTextField: UITextField!
    // passWord
    @IBOutlet weak var passWordTextField: UITextField!
    // userImage
    @IBOutlet weak var userProfImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfImage.layer.cornerRadius = 15
        
        // ボーダーだけに
        emailTextField.addBorderBottom(height: 1, color: .white)
        ageTextField.addBorderBottom(height: 1, color: .white)
        nameTextField.addBorderBottom(height: 1, color: .white)
        passWordTextField.addBorderBottom(height: 1, color: .white)
        
        emailTextField.delegate = self
        ageTextField.delegate = self
        nameTextField.delegate = self
        passWordTextField.delegate = self
        
        profTextView.delegate = self
        // textviewのtextの量に応じて,textviewの高さを決める
        profTextView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // 新規登録ボタン
    @IBAction func createAccount(_ sender: Any) {
        
    }
    // テキストフィールドを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
    
    // テキストフィールド以外を触った時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        if (self.profTextView.isFirstResponder) {
            self.profTextView.resignFirstResponder()
        }
    }
    
}
