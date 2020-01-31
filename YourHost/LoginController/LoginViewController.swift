//
//  LoginViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/01/30.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // email
    @IBOutlet weak var emailTextField: UITextField!
    // pasword
    @IBOutlet weak var passWordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンを丸く
        loginButton.layer.cornerRadius = 15
        googleLoginButton.layer.cornerRadius = 15
        
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationbarを消す
        self.navigationController?.isNavigationBarHidden = true
    }
    

    // emailログイン
    @IBAction func login(_ sender: Any) {
        
    }
    
    // googleログイン
    @IBAction func googleLogin(_ sender: Any) {
         
    }
    
    // メンバー登録
    @IBAction func signUp(_ sender: Any) {
    }
    
}
