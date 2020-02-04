//
//  NewMemberSettingViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/02.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase

class NewMemberSettingViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // 名前
    @IBOutlet weak var nameTextField: UITextField!
    // email
    @IBOutlet weak var emailTextField: UITextField!
    // passWord
    @IBOutlet weak var passWordTextField: UITextField!
    // userImage
    @IBOutlet weak var userProfImage: UIImageView!
    // age
    @IBOutlet weak var ageTextField: UITextField!
    // アラート用
    var alertController:UIAlertController!
    // 新規登録ボタン
    @IBOutlet weak var createAccountButton: UIButton!
    // 性別
    @IBOutlet weak var ChoseSex: UISegmentedControl!
    // プロフ写真変更ボタン
    @IBOutlet weak var profButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // uiimage を丸く
        userProfImage.layer.cornerRadius = 30
        
        // ボーダーだけに
        emailTextField.addBorderBottom(height: 1, color: .gray)
        nameTextField.addBorderBottom(height: 1, color: .gray)
        passWordTextField.addBorderBottom(height: 1, color: .gray)
        ageTextField.addBorderBottom(height: 1, color: .gray)
        
        // textfiledデリゲートの設定
        emailTextField.delegate = self
        nameTextField.delegate = self
        passWordTextField.delegate = self
        ageTextField.delegate = self
        
        // ボタンを丸く
        createAccountButton.layer.cornerRadius = 15
        profButton.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController をけす
        navigationController?.isNavigationBarHidden = true
    }
    
    // カメラ立ち上げ
    func openCamera() {
        
        let sourceType:UIImagePickerController.SourceType = .camera
        // カメラが利用可能かチェックする
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            print("カメラが開かれました")
        }
    }
    
    // アルバム立ち上げ
    func openAlbum() {
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェックする
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            print("アルバムを開きました")
        }
        
    }
    
    // カメラで取られた画像、アルバムで選ばれた画像が入る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil {
            let selctedImage = info[.originalImage] as! UIImage
            
            UserDefaults.standard.set(selctedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            
            userProfImage.image = selctedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    //キャンセルが押されたとき
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // プロフィール画像変更、設定
    @IBAction func profImageTap(_ sender: Any) {
        // アラートを出す
        // カメラorアルバムを選択させる
        cameraAlert()
    }
    
    // 新規登録ボタン
    @IBAction func createAccount(_ sender: Any) {
        // もしnilの場合はここでreturnを返す
        guard let email = emailTextField.text, let passWord = passWordTextField.text, let age = ageTextField.text, let name = nameTextField.text, let profImage = userProfImage.image else {
            return
            print("nil")
            createAlert(title: "正しく入力されていません", message: "もう一度お願いします")
        }
        //　nilがなければこの続きの処理に行く
        Auth.auth().createUser(withEmail: email, password: passWord) { (user, error) in
            if let errro = error {
                print("新規登録失敗")
                print(error)
                self.showErrorAlert(error: error)
            } else {
                print("新規登録成功")
                self.toTimeLine()
            }
        }
        
      
    }
    
    // テキストフィールドを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
    
    // キーボード以外を触ったときの処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // エラーが返ってきた場合のアラート
    func showErrorAlert(error: Error?)  {
        let alert = UIAlertController(title: "入力が正しくありません", message: "もう一度お願いします", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        // 表示
        self.present(alert, animated: true)
    }
    
    // 自分でアラートの文字を入れることができる
    func createAlert(title:String,message:String) {
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController,animated: true)
        
    }
    
    // 年齢がありえないものにならないようにする
    @IBAction func yourAgeTextField(_ sender: Any) {
        
        let yourAge:Int? = Int(ageTextField.text!)
        
        if yourAge! <= 10 {
            createAlert(title: "年齢が低すぎます", message: "もう一度お願いします")
            ageTextField.text = ""
        } else if  yourAge! > 100{
            createAlert(title: "年齢が高すぎます", message: "もう一度お願いします")
            ageTextField.text = ""
        } else {
            return
        }
          
        
    }
    
    func toTimeLine (){
        print("タイムラインへ")
        let nextVC = storyboard?.instantiateViewController(identifier: "TimeLine") as! TimeLineViewController
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
    
    
    // カメラ使用時のアラート
    func cameraAlert() {
        let alertController = UIAlertController(title: "選択してください", message: "こちらから選べます", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.openCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.openAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

