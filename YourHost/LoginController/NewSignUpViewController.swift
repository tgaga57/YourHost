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
    
    // アラート用
    var alertController:UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 登録
    @IBAction func createButton(_ sender: Any) {
               
        Auth.auth().signIn(withEmail: emailTextField.text!, link: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error)
                self.createAlert(title: "入力が正しく行われていません", message: "もう一度お願いします")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            
            } else {
                print("新しくアカウントが登録されました")
            }
        }
    }
    
    // backbutton
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        print("最初の画面にもどります")
    }
    
    
    //  アラートの生成
    // 引数に自分でアラートの文字を入れることができる
    func createAlert(title:String,message:String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController,animated: true)
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
