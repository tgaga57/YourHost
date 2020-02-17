//
//  ProfViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/06.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase

class ProfViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // view
    @IBOutlet weak var backView: UIView!
    // プロフィール写真
    @IBOutlet weak var profImageView: UIImageView!
    // 名前
    @IBOutlet weak var nameTextFiled: UITextField!
    // 年齢
    @IBOutlet weak var ageTextFiled: UITextField!
    // 性別
    @IBOutlet weak var sexSegment: UISegmentedControl!
    // 自己紹介
    @IBOutlet weak var introduceYourSelfTextView: UITextView!
    // プロフィール更新
    @IBOutlet weak var prfofileUpdate: UIButton!

    // database用
    var ref: DocumentReference!
    
    // インスタンス化
    let db = Firestore.firestore()
    
    // ログイン情報
    var uID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.layer.cornerRadius = 25
        profImageView.layer.cornerRadius = 50
        
        ageTextFiled.delegate = self
        nameTextFiled.delegate = self
        
        nameTextFiled.addBorderBottom(height: 1, color: .systemPink)
        ageTextFiled.addBorderBottom(height: 1, color: .systemPink)
        
        prfofileUpdate.layer.cornerRadius = 15

        // プロフィールの情報を反映
        getProfile()
        
    }
    
    //userの情報を反映させる
    func getProfile(){
        
        // usersの中のログインした本人のプロフィール情報を取ってくる
        db.collection("users").document(uID).getDocument { (snap, error) in
            if let error = error {
                // エラーなら
                print(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else {return}
            print(data)
            // ドキュメントのデータを反映
            self.nameTextFiled.text = data["userName"] as! String
            self.ageTextFiled.text = data["userAge"] as! String
            self.sexSegment.selectedSegmentIndex = Int(data["userGender"] as! String)!
            // 画像情報を取得
            let profileImage = data["userImage"] as! String
            // NSData型に変換
            let dataProfileimage = NSData(base64Encoded: profileImage, options: .ignoreUnknownCharacters)
            // UIImage型に変換
            let decodePostImage = UIImage(data: dataProfileimage! as Data)
            // profileImageに反映
            self.profImageView.image = decodePostImage
            self.profImageView.contentMode = .scaleToFill
            
            // userのプロフィールイメージをダウンロード
            let storage = Storage.storage()
            let storateRef = storage.reference()
            let userImage = storateRef.child("user\(self.uID)")
            print("userImage\(userImage)")
            
            
            
        }
        
       
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
            // userImageを保存
            UserDefaults.standard.set(selctedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            profImageView.image = selctedImage
            // 画面に反映
            picker.dismiss(animated: true, completion: nil)
            
        }
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
    
    //キャンセルが押されたとき
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // プロフィール写真を変更
    @IBAction func changeImageButton(_ sender: Any) {
    }
    
    // プロフィールアップデート
    @IBAction func profUpdateButton(_ sender: Any) {
    }
    
    
    // リターンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextFiled.resignFirstResponder()
        ageTextFiled.resignFirstResponder()
        introduceYourSelfTextView.resignFirstResponder()
        
        return true
    }
    // 他の部分を触ったらviewを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
