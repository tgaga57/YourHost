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
    
    var uid:String = ""
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
        
        // Add a second document with a generated ID.
        ref = db.collection("users").document("Post").collection("name").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        
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
                // uIDをオプショナルバインディング
                guard let userID = Auth.auth().currentUser?.uid else {
                    return
                }
                print("ログイン成功")
                let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let toTimeLineVC = storyboard.instantiateViewController(withIdentifier: "TimeLine") as! HomeViewController
                toTimeLineVC.modalPresentationStyle = .fullScreen
                // 情報を受け渡す
                toTimeLineVC.userID = userID
                // 情報を受け渡す
                self.present(toTimeLineVC, animated: true, completion: nil)
                print("タイムラインへ")
                
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
    
    // 数字しか打ち込めなくする
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // 年齢のところのkeybordは数字しか打てないようにする
           if textField.tag == 1 {
               
               // 0から9までの数字しか許さない
               let allowedCharacters = "0123456789"
               // この中にallowedChraracrtesを入れる
               let charactersSet = CharacterSet(charactersIn: allowedCharacters)
               // String型
               let typedCharacterSet = CharacterSet(charactersIn: string)
               
               // 入力を反映させたテキストを取得する
               // 文字数の制限
               // 文字数は2まで
               let resultText: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
               if resultText.count <= 2 {
                   return charactersSet.isSuperset(of: typedCharacterSet)
               } else {
                   return false
               }
           }
           return true
       }
    
    
    
}


