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
import NVActivityIndicatorView

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
    // インジゲーターの変数
    var activityIndicatorView: NVActivityIndicatorView!
    // ロード時画面のview
    var indicatorBackgroundView: UIView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //プロフィール情報をfirebaseから反映
        getProfile()
        // インジゲーターのサイズ
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
        // インジゲーターをセンターへ
        activityIndicatorView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
        // インジケーターの種類
        activityIndicatorView.type = .ballPulse
        // 色
        activityIndicatorView.color = .green
        // viewにaddsubview
        self.view.addSubview(activityIndicatorView)
        
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
            self.introduceYourSelfTextView.text = (data["userInfo"] as! String)
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
            
            // 画像を画面全体に反映
            profImageView.contentMode = .scaleToFill
            // userProfileに反映
            profImageView.image = selctedImage
            // 戻る
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
        // カメラを起動
        cameraAlert()
    }
    
    // プロフィールアップデート
    @IBAction func profUpdateButton(_ sender: Any) {
        // 更新ボタンを押せなくする
        self.prfofileUpdate.isEnabled = false
        // nilを排除
        guard let name = nameTextFiled.text,let age = ageTextFiled.text,let userInfo = introduceYourSelfTextView.text else {
            print("nil")
            return
        }
        print("nilはなかったよ!")
        
        activityIndicatorView.startAnimating()
        // data型
        var profImageData: NSData = NSData()
        
        if let profileImage = profImageView.image{
            profImageData = profileImage.jpegData(compressionQuality: 0.1) as! NSData
        }
        // base64にエンコード
        let base64UserImage = profImageData.base64EncodedString(options: .lineLength64Characters) as String
        
        // usergender
        var userGender = String(sexSegment.selectedSegmentIndex)
        
        let userRef = db.collection("users").document(uID)
        userRef.updateData(["userName":name,"userGender":userGender,"userAge":age,"userImage":base64UserImage,"userInfo":userInfo]) { (error) in
            
            if error != nil {
                print(error?.localizedDescription)
                print("更新失敗")
                // アニメーションをストップ
                self.activityIndicatorView.stopAnimating()
                // 更新ボタンを使用可能に
                self.prfofileUpdate.isEnabled = true
                return
            } else {
                print("更新成功")
                // アニメーションをストップ
                self.activityIndicatorView.stopAnimating()
                // 更新ボタンを使用可能に
                self.prfofileUpdate.isEnabled = true
                // プロフィールを更新
                self.getProfile()
                //　back
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
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
    
    // back
    @IBAction func backButton(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Agetextのところは数字しか使えなくする
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



