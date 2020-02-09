//
//  NewMemberSettingViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/02.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

// scrollView内でtouchesBeganが使えるように
extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

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
    
    
    var fileName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // uiimage を丸く
        userProfImage.layer.cornerRadius = 30
        
        // ボーダーだけに
        emailTextField.addBorderBottom(height: 1, color: .purple)
        nameTextField.addBorderBottom(height: 1, color: .purple)
        passWordTextField.addBorderBottom(height: 1, color: .purple)
        ageTextField.addBorderBottom(height: 1, color: .purple)
        
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
            
            // 画像を画面全体に反映
            userProfImage.contentMode = .scaleToFill
            // userProfileに反映
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
        
        //  全てに記入がされているかの確認
        guard let email = emailTextField.text, let passWord = passWordTextField.text, let userAge = ageTextField.text, let userName = nameTextField.text, let userImage = userProfImage.image else{
            print("nil")
            createAlert(title: "入力されていない項目があります", message: "もう一度お願いします")
            return
            
        }
        
        //        let userSex = String(ChoseSex.selectedSegmentIndex)
        
        Auth.auth().createUser(withEmail: email, password: passWord) { (result, error) in
            // エラーがないかチェック
            if error != nil{
                self.showErrorAlert(error: error)
            } else {
                let uploadRef = Storage.storage().reference(withPath: "user/\(String(describing: result?.user.uid)).jpg")
                guard let imageData = self.userProfImage.image?.jpegData(compressionQuality: 0.1) else {return}
                
                let uploadMetaData = StorageMetadata.init()
                uploadMetaData.contentType = "image/jpeg"
                
                uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
                    if let error = error {
                        print("画像をアップロードできませんでした")
                        print("errroを見つけました! \(error.localizedDescription)")
                        return
                    }
                    print("画像をアップロードしました\(String(describing: downloadMetaData))")
                    
                }
                
                let db = Firestore.firestore()
                
                let userSex = String(self.ChoseSex.selectedSegmentIndex)
                
                var profImageData: NSData = NSData()
                
                if let profileImage = self.userProfImage.image{
                    profImageData = profileImage.jpegData(compressionQuality: 0.1)! as NSData
                }
                let base64UserImage = profImageData.base64EncodedString(options: .lineLength64Characters) as String
                db.collection("users").addDocument(data: ["email":email,"userName":userName,"userAge":userAge,"userGender":userSex,"uid": result!.user.uid,"userImage":base64UserImage]) { (error) in
                    if error != nil {
                        self.showErrorAlert(error: error)
                        print("新規登録失敗")
                    } else {
                        print("新規登録成功")
                        // タイムラインへ遷移
                        self.toTimeLine()
                        
                    }
                }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // エラーが返ってきた場合のアラート
    func showErrorAlert(error: Error?)  {
        let alert = UIAlertController(title: "入力されていない項目があります", message: "もう一度お願いします", preferredStyle: .alert)
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
    // タイムラインへ
    func toTimeLine (){
        print("タイムラインへ")
        
        // 遷移する先
        let storyboard: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let toTimeLineVC = storyboard.instantiateViewController(withIdentifier: "TimeLine")
        toTimeLineVC.modalPresentationStyle = .fullScreen
        present(toTimeLineVC, animated: true, completion: nil)
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
    
    // 性別
    @IBAction func yourGender(_ sender: Any) {
        if ChoseSex.selectedSegmentIndex == 0 {
            print("女性")
        } else if ChoseSex.selectedSegmentIndex == 1{
            print("男性")
        } else {
            print("その他")
        }
    }
    
    // ログイン画面に戻る
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


