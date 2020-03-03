//
//  Post6ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/28.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class Post6ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // title label
    @IBOutlet weak var titleLabel: UILabel!
    // ホスティングできる日にち
    var beginAcceptanceDate:String! = ""
    var finishAcceptanceDate:String! = ""
    // firebase
    let db = Firestore.firestore()
    // strage
    let storage = Storage.storage()
    // images
    private var images: [UIImage] = []
    // 何が選択されたかを判断
    private var selectedImageNo: Int = 0
    // ユーザーが選ぶ写真
    @IBOutlet weak var userPickedImage1: UIImageView!
    @IBOutlet weak var userPickedImage2: UIImageView!
    @IBOutlet weak var userPickedImage3: UIImageView!
    @IBOutlet weak var userPickedImage4: UIImageView!
    
    // textView
    @IBOutlet weak var textView: UITextView!
    // アラート
    var alertController = UIAlertController()
    // userDefaluts
    let userdefaluts = UserDefaults.standard
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(beginAcceptanceDate as Any)
        print(finishAcceptanceDate as Any)
        
        // 最初にimageを入れておく
        self.images = [UIImage(named: "アルバム")!,UIImage(named: "アルバム")!,UIImage(named: "アルバム")!,UIImage(named: "アルバム")!]
        // imageを呼び出す
        loadImage()
        // imageviewのタグ
        userPickedImage1.tag = 0
        userPickedImage2.tag = 1
        userPickedImage3.tag = 2
        userPickedImage4.tag = 3
        
        configureNotification()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNotification()
    }
    
    // nortificationメソッド化
    func configureNotification () {
        // キーボード出てくるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(Post6ViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // キーボード閉じるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(Post6ViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが呼び出される時
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardwillshow発動")
    }
    // キーボードを消す時
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
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
    
    func loadImage () {
        userPickedImage1.contentMode = .scaleToFill
        userPickedImage1.image = self.images[0]
        userPickedImage2.contentMode = .scaleToFill
        userPickedImage2.image = self.images[1]
        userPickedImage3.contentMode = .scaleToFill
        userPickedImage3.image = self.images[2]
        userPickedImage4.contentMode = .scaleToFill
        userPickedImage4.image = self.images[3]
    }
    
    // カメラで取られた画像、アルバムで選ばれた画像が入る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil {
            let selectedImage = info[.originalImage] as! UIImage
            // どのタグかを入れる
            self.images[selectedImageNo] = selectedImage
            // ロードimageを入れる
            loadImage()
        }
        // 戻る
        picker.dismiss(animated: true, completion: nil)
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
        
        // addAction
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // 写真ボタン
    @IBAction func button1(_ sender: Any) {
        // タグの番号を入れる
        selectedImageNo = userPickedImage1.tag
        cameraAlert()
    }
    // 写真ボタン
    @IBAction func button2(_ sender: Any) {
        // タグの番号を入れる
        selectedImageNo = userPickedImage2.tag
        cameraAlert()
    }
    // 写真ボタン
    @IBAction func button3(_ sender: Any) {
        // タグの番号を入れる
        selectedImageNo = userPickedImage3.tag
        cameraAlert()
    }
    
    @IBAction func button4(_ sender: Any) {
        // タグの番号を入れる
        selectedImageNo = userPickedImage4.tag
        cameraAlert()
    }
    
    //キャンセルが押されたとき
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // textview用
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    // アラート
    func Alert(title:String,message:String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController,animated: true)
    }
    
    // 投稿していいかのアラートを出す
    func postconfirmationAlert() {
        let alert:UIAlertController = UIAlertController(title: "投稿する準備が整いました", message: "あなたが入力した情報が、全てタイムラインに乗りますがよろしいですか?", preferredStyle: UIAlertController.Style.alert)
        
        let okAction:UIAlertAction = UIAlertAction(title: "Okay", style: .default) { (alert) in
            print("Ok")
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            return
        }
        // アラートにadd
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 掲載するボタン
    @IBAction func postAll(_ sender: Any) {
        
        postconfirmationAlert()
        
        if self.userPickedImage1.image == UIImage(named: "アルバム") && self.userPickedImage2.image == UIImage(named: "アルバム") && self.userPickedImage3.image == UIImage(named: "アルバム") && self.userPickedImage4.image == UIImage(named: "アルバム") {
            
            self.Alert(title: "写真が全て投稿されていません", message: "もう一度お願いします")
            print("写真が全て投稿されていない")
            return
        } else if self.textView.text == "" {
         self.Alert(title: "ゲストへのメッセージが何も入力されていません", message: "もう一度お願いします")
         print("ゲストへのメッセージなし")
        return
    }
        
    // post1
    let uid = userID
    let categoryText = userdefaluts.string(forKey: "categoryText")
    let buildingText = userdefaluts.string(forKey: "buildingText")
    let selectedTag = userdefaluts.string(forKey: "selectedTag")
    // post2
    let numberOfGuestCount = userdefaluts.string(forKey: "numberOfGuestCount")
    let numberOfGuestBedroomCount = userdefaluts.string(forKey: "numberOfGuestBedroomCount")
    let numberOfGuestBedCount = userdefaluts.string(forKey: "numberOfGuestBedCount")
    // post3
    let yourAdress = userdefaluts.string(forKey: "yourAdress")
    let yourKeyWord = userdefaluts.string(forKey: "yourKeyWord")
    // post4
    let count1 = userdefaluts.string(forKey: "count1")
    let count2 = userdefaluts.string(forKey: "count2")
    let count3 = userdefaluts.string(forKey: "count3")
    let count4 = userdefaluts.string(forKey: "count4")
    let count5 = userdefaluts.string(forKey: "count5")
    let count6 = userdefaluts.string(forKey: "count6")
    let count7 = userdefaluts.string(forKey: "count7")
    let count8 = userdefaluts.string(forKey: "count8")
    
    // textViewがnilがないか
    guard let forGuestMessage = textView.text else{
    print("nil")
    return
    }
        
    // imagedata
       guard let imageData1 = self.userPickedImage1.image,let imageDate2 = self.userPickedImage2.image,let imageData3 = self.userPickedImage3.image,let imageData4 = self.userPickedImage4.image else{return}
    
    // 辞書型で入れていく
        let toDataSave = ["categoryText":categoryText,"buildingText":buildingText,"selectedTag":selectedTag,"numberOfGuestCount":numberOfGuestCount,"numberOfGuestBedroomCount":numberOfGuestBedroomCount,"numberOfGuestBedCount":numberOfGuestBedCount,"yourAdress":yourAdress,"yourKeyWord":yourKeyWord,"count1":count1,"count2":count2,"count3":count3,"count4":count4,"count5":count5,"count6":count6,"count7":count7,"count8":count8,"forGuestMessage":forGuestMessage]
    
    // userの投稿情報の新しいコレクションを作る
    // ドキュメントはuidとする
    let userData = db.document("userPosts/\(String(describing: uid))/\(Timestamp(date: Date()))")
    
    userData.setData(toDataSave as [String : Any]) { (error) in
    // errorなら
    if let error = error {
    print("\(error)")
    } else {
    print("Document add with Id\(String(describing: uid))")
    // imagedata
    guard let imageData1 = self.userPickedImage1.image,let imageDate2 = self.userPickedImage2.image,let imageData3 = self.userPickedImage3.image,let imageData4 = self.userPickedImage4.image else{return}

    // 配列として保持
    let arrayImage = [imageData1,imageDate2,imageData3,imageData4]
    // for文で回す
    for image in arrayImage {
    let imageName = UUID.init().uuidString
    // uploadRefの中に入れる
        let uploadRef = self.storage.reference(withPath:"userPosts").child("\(String(describing: uid))").child("\(Timestamp(date: Date()))").child(imageName)
    // imageDataの中にはfor文で回されたimageの中のが入ってくる
    guard let imageData = image.jpegData(compressionQuality: 0.05) else {return}
    
    let uploadMetaData = StorageMetadata.init()
    // imageのタイプ
    uploadMetaData.contentType = "image/jpeg"
    uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetaData, error) in
    if let error = error {
    print("画像をアップロードできません")
    print("errorを見つけました\(error.localizedDescription)")
    return
    }
    print("画像をアップロードしたよ")
    
    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TimeLine") as! HomeViewController
    self.present(nextVC, animated: true, completion: nil)
         }
        }
      }
    }
}


    
// back
@IBAction func back(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
}


}




