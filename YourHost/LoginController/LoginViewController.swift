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
import NVActivityIndicatorView

// textfieldをカスタム
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}


class LoginViewController: UIViewController,UITextFieldDelegate{
    
    
    // email
    @IBOutlet weak var emailTextField: UITextField!
    // pasword
    @IBOutlet weak var passWordTextField: UITextField!
    // loginButton
    @IBOutlet weak var loginButton: UIButton!
    
    // activeIndicator
    @IBOutlet weak var activeIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: UIButton!
    // facebook
    @IBOutlet weak var fbButton: UIButton!
    //　アラート用
    var alertController:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンを丸く
        loginButton.layer.cornerRadius = 15
        fbButton.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        // デリゲートの設定
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
        // テキストフィールドをボーダーだけに
        emailTextField.addBorderBottom(height: 1.0, color: UIColor.purple)
        passWordTextField.addBorderBottom(height: 1.0, color: UIColor.purple)
        
        // テキストフィールドの角を丸く
        emailTextField.layer.cornerRadius = 10
        passWordTextField.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationbarを消す
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //　アニメーションストップ
        activeIndicatorView.stopAnimating()
        
    }
    
    // emailログイン
    @IBAction func login(_ sender: Any) {
        if emailTextField.text == nil && passWordTextField.text == nil {
            print("なにも入っていません")
            return
        }
        // スタートアニメーション
        activeIndicatorView.color = .green
        activeIndicatorView.startAnimating()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passWordTextField.text!) { (usr, error) in
            if error != nil {
                print("ログイン失敗")
                print(error)
                self.createAlert(title: "正しく入力が行われていないかアカウントが存在しません", message: "もう一度おねがいします")
                self.emailTextField.text = ""
                self.passWordTextField.text = ""
                self.activeIndicatorView.stopAnimating()
            }else {
                print("ログイン成功")
                self.toTimeLine()
            }
        }
    }
    
    // facebookログイン
    @IBAction func facebookLogin(_ sender: Any) {
        // スタートアニメーション
        activeIndicatorView.color = .green
        activeIndicatorView.startAnimating()
        
        let manager = LoginManager()
        manager.logIn(permissions: [Permission.publicProfile], viewController: self) { (result) in
            
            switch result {
            // もしエラーなら
            case .failed(let error):
                print(error)
            // キャンセルしたら
            case .cancelled:
                print("ログインをキャンセルしました")
                self.activeIndicatorView.stopAnimating()
            // 成功したら
            case .success(let garantedPermision, let declinedPermision , let accesToken):
                print("facebookでログイン")
                self.toTimeLine()
            }
        }
    }
    
    
    // 新規メンバー登録
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
    
    // タイムラインへのメソッド
    func toTimeLine(){
        print("タイムラインへ")
        let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let toTimeLineVC = storyboard.instantiateViewController(withIdentifier: "TimeLine")
        toTimeLineVC.modalPresentationStyle = .fullScreen
        present(toTimeLineVC, animated: true, completion: nil)
    }
    
    
}
