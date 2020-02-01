//
//  LoginViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController,UITextFieldDelegate{
    
    
    // email
    @IBOutlet weak var emailTextField: UITextField!
    // pasword
    @IBOutlet weak var passWordTextField: UITextField!
    // loginButton
    @IBOutlet weak var loginButton: UIButton!
    // googleLoginButton
    @IBOutlet weak var googleLoginButton: UIButton!
    
    // アラート用
    var alertController:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンを丸く
        loginButton.layer.cornerRadius = 15
        googleLoginButton.layer.cornerRadius = 15
        
        // デリゲートの設定
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationbarを消す
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
        
    }
    
    
    // emailログイン
    @IBAction func login(_ sender: Any) {
        // email,passwordがnilならreturn
        guard let email = emailTextField.text, let passWord = passWordTextField.text else {
            return
        }
          // nilでないなら下の処理に移動
        Auth.auth().signIn(withEmail: email, password: passWord) { (user, error) in
            if let error = error {
                self.createAlert(title: "入力が正しく行われていないかアカウントが存在しません", message: "もう一度お願いします")
                self.emailTextField.text = ""
                self.passWordTextField.text = ""
                print("ログイン失敗")
            }else {
                print("ログイン成功")
                UserDefaults.standard.set("Check", forKey: "set")
                
                //タイムラインへ遷移
                self.toTimeLine()
            }
        }
            
        }
    
    // facebookログイン
    @IBAction func facebookLogin(_ sender: Any) {
        
        if AccessToken.current == nil {
            let TimeLineVC = self.storyboard?.instantiateViewController(identifier: "TimeLine") as! TimeLineViewController
            TimeLineVC.modalPresentationStyle = .fullScreen
            self.present(TimeLineVC, animated: true, completion: nil)
            print("ログイン")
        }else {
            let manager = LoginManager()
            manager.logIn(permissions: [Permission.publicProfile], viewController: self) { (result) in
                
                switch result {
                // もしエラーなら
                case .failed(let error):
                    print(error)
                // キャンセルしたら
                case .cancelled:
                    print("ログインをキャンセルしました")
                    return
                    // 成功したら
                    
                case .success(let garantedPermision, let declinedPermision , let accesToken):
                    print("facebookでログイン")
                    self.toTimeLine()
                }
            }
        }
        
    }
    
    // あたらしいメンバー登録に
    @IBAction func signUp(_ sender: Any) {
        print("signupページに移動")
    }
    
    // テキストフィールドを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
        return true
    }
    
    // テキストフィールド以外を触った時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //  アラートの生成
    // 引数に自分でアラートの文字を入れることができる
    func createAlert(title:String,message:String) {
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController,animated: true)
        
    }
    
    func toTimeLine() {
        // 遷移処理
        let TimeLineVC = self.storyboard?.instantiateViewController(identifier: "TimeLine") as! TimeLineViewController
        // 遷移後はフルスクリーンに
        TimeLineVC.modalPresentationStyle = .fullScreen
        self.present(TimeLineVC, animated: true, completion: nil)
    }
    
    
}
