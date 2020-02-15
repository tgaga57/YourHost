//
//  LoginViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import FirebaseFirestore

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
    
    let db = Firestore.firestore()
    
    
    // email
    @IBOutlet weak var emailTextField: UITextField!
    // pasword
    @IBOutlet weak var passWordTextField: UITextField!
    // loginButton
    @IBOutlet weak var loginButton: UIButton!
    
    // activeIndicator
    @IBOutlet weak var activeIndicatorView: NVActivityIndicatorView!
    // 新規登録
    @IBOutlet weak var signUpButton: UIButton!
    
    var ref:DocumentReference!
    
    var userID = Auth.auth().currentUser?.uid
    
    // アラート用
    var alertController:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ボタンを丸く
        loginButton.layer.cornerRadius = 15
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
                // アニメーションをとめる
                self.activeIndicatorView.stopAnimating()
            }else {
                print("ログイン成功")
                let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
                let toTimeLineVC = storyboard.instantiateViewController(withIdentifier: "TimeLine") as! HomeViewController
                toTimeLineVC.modalPresentationStyle = .fullScreen
                // 情報を受け渡す
                toTimeLineVC.userID = self.userID!
                self.present(toTimeLineVC, animated: true, completion: nil)
                print("タイムラインへ")
                print(self.userID)
                
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
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let toTimeLineVC = storyboard.instantiateViewController(withIdentifier: "TimeLine") as! HomeViewController
        toTimeLineVC.modalPresentationStyle = .fullScreen
        present(toTimeLineVC, animated: true, completion: nil)
        print("タイムラインへ")
    }
    
    
    
}
