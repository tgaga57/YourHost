//
//  NewSignUpViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/01.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase

class NewSignUpViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createButoon: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        createButoon.layer.cornerRadius = 15
        
        backButton.layer.cornerRadius = 15
        emailTextField.addBorderBottom(height: 1.0, color: UIColor.black)
        passwordTextField.addBorderBottom(height: 1.0, color: UIColor.black)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 登録ボタン
    @IBAction func createButton(_ sender: Any) {
        // emailとpasswordがnilならreturn
        guard let email = emailTextField.text,let passWord = passwordTextField.text else {
            return
        } // nil でないならこの処理をする
        Auth.auth().createUser(withEmail: email, password: passWord) { (user, error) in
            if let error = error {
                self.showErrorAlert(error: error)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            } else {
                print("新規登録成功")
                UserDefaults.standard.set("check", forKey: "set")
                // 遷移処理
                self.performSegue(withIdentifier: "Setting", sender: nil)
            }
        }
    }
    
    // backbutton
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        print("最初の画面にもどります")
    }
    
    // エラーが返ってきた場合のアラート
    func showErrorAlert(error: Error?)  {
        let alert = UIAlertController(title: "入力が正しくありません", message: "もう一度お願いします", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        // 表示
        self.present(alert, animated: true)
    }
    
    // リターンを押したときをキーボードを消す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    //  キーボード以外を押したときキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

