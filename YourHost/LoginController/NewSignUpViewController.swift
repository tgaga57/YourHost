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
        // emailとpasswordがnilならreturn
        guard let email = emailTextField.text,let passWord = passwordTextField.text else {
           return
        } // nil でないならこの処理をする
        Auth.auth().createUser(withEmail: email, password: passWord) { (user, error) in
            
            if let error = error {
                self.showErrorAlert(error: error)
            } else {
                print("新規登録成功")
                UserDefaults.standard.set("check", forKey: "set")
                // 遷移処理
                self.toTimeLine()
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
           let alert = UIAlertController(title: "正しく入力がおこなわていないかアカウントがすでに存在します", message: "もう一度お願いします", preferredStyle: .alert)
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
    
    func toTimeLine() {
        let toTimeLineVC = storyboard?.instantiateViewController(withIdentifier: "TimeLine") as! TimeLineViewController
        toTimeLineVC.modalPresentationStyle = .fullScreen
        present(toTimeLineVC, animated: true, completion: nil)
    }
}
