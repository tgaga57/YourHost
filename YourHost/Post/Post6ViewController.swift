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
import NVActivityIndicatorView

class Post6ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // インジゲーターの変数
    var activityIndicatorView: NVActivityIndicatorView!
    // ロード時画面のview
    var indicatorBackgroundView: UIView!
    
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
    
    // userPostImage
    var fileName1:String?
    var fileName2:String?
    var fileName3:String?
    var fileName4:String?
    
    // アラート
    var alertController = UIAlertController()
    // userDefaluts
    let userdefaluts = UserDefaults.standard
    // uis
    var userID = ""
    
    
    // title label
    @IBOutlet weak var titleLabel: UILabel!
    // ユーザーが選ぶ写真
    @IBOutlet weak var userPickedImage1: UIImageView!
    @IBOutlet weak var userPickedImage2: UIImageView!
    @IBOutlet weak var userPickedImage3: UIImageView!
    @IBOutlet weak var userPickedImage4: UIImageView!
    
    // textView
    @IBOutlet weak var textView: UITextView!
    
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
        
        // キーボードをかぶらないように
        configureNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボードを閉じる
        configureNotification()
        
        // インジゲーターのサイズ
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
        // インジゲーターをセンターへ
        activityIndicatorView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
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
    
    // imageのロード
    func loadImage () {
        userPickedImage1.contentMode = .scaleAspectFill
        userPickedImage1.image = self.images[0]
        userPickedImage2.contentMode = .scaleAspectFill
        userPickedImage2.image = self.images[1]
        userPickedImage3.contentMode = .scaleAspectFill
        userPickedImage3.image = self.images[2]
        userPickedImage4.contentMode = .scaleAspectFill
        userPickedImage4.image = self.images[3]
    }
    
    
    // カメラで取られた画像、アルバムで選ばれた画像が入る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageURL = info[.imageURL] as? URL else {
            print("URL取得できず")
            return
        }
        
        let selectedImage = info[.originalImage] as! UIImage
        //　投稿写真を反映
        self.images[selectedImageNo] = selectedImage
        
        // imageUrlをtagの番号によって付けていく
        switch selectedImageNo {
        case 0:
            fileName1 = imageURL.lastPathComponent
            print(fileName1!)
        case 1:
            fileName2 = imageURL.lastPathComponent
            print(fileName2!)
        case 2:
            fileName3 = imageURL.lastPathComponent
            print(fileName3!)
        case 3:
            fileName4 = imageURL.lastPathComponent
            print(fileName4!)
        default:
            break
        }
        // ロードimageを入れる
        loadImage()
        // 戻る
        picker.dismiss(animated: true, completion: nil)
    }
    
    // カメラ使用時のアラート
    func cameraAlert() {
        let alertController = UIAlertController(title: "選択してください", message: "こちらから選べます", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.openAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        // addAction
        alertController.addAction(action1)
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
    // 写真ボタン
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
            if self.userPickedImage1.image == UIImage(named: "アルバム") && self.userPickedImage2.image == UIImage(named: "アルバム") && self.userPickedImage3.image == UIImage(named: "アルバム") && self.userPickedImage4.image == UIImage(named: "アルバム") {
                self.Alert(title: "写真が全て投稿されていません", message: "もう一度お願いします")
                print("写真が全て投稿されていない")
                return;
            } else if self.textView.text == "" {
                self.Alert(title: "ゲストへのメッセージが何も入力されていません", message: "もう一度お願いします")
                print("ゲストへのメッセージなし")
                return;
            }
            
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            return
        }
        // アラートにadd
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 投稿をチェック
    func checkPost(){
        if self.userPickedImage1.image == UIImage(named: "アルバム") || self.userPickedImage2.image == UIImage(named: "アルバム") || self.userPickedImage3.image == UIImage(named: "アルバム") || self.userPickedImage4.image == UIImage(named: "アルバム") {
            self.Alert(title: "写真が全て投稿されていません", message: "もう一度お願いします")
            print("写真が全て投稿されていない")
            return;
        } else if self.textView.text == "" {
            self.Alert(title: "ゲストへのメッセージが何も入力されていません", message: "もう一度お願いします")
            print("ゲストへのメッセージなし")
            return;
        }
    }
    
    // 掲載するボタン
    @IBAction func postAll(_ sender: Any) {
        
        if self.userPickedImage1.image == UIImage(named: "アルバム") || self.userPickedImage2.image == UIImage(named: "アルバム") || self.userPickedImage3.image == UIImage(named: "アルバム") || self.userPickedImage4.image == UIImage(named: "アルバム") {
            self.Alert(title: "写真が全て投稿されていません", message: "もう一度お願いします")
            print("写真が全て投稿されていない")
            return;
            
        } else if self.textView.text == "" {
            self.Alert(title: "ゲストへのメッセージが何も入力されていません", message: "もう一度お願いします")
            print("ゲストへのメッセージなし")
            
            return;
        }
        
        print("確認が終わったよ")
        // インディケータースタート
        showLodeIndicator()
        /// 持ってきたかった情報
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
        let necessaryCount = userdefaluts.string(forKey: "count1")
        let wifiCount = userdefaluts.string(forKey: "count2")
        let kitchenCount = userdefaluts.string(forKey: "count3")
        let heaterCount = userdefaluts.string(forKey: "count4")
        let airConCount = userdefaluts.string(forKey: "count5")
        let tvCount = userdefaluts.string(forKey: "count6")
        let laundryCount = userdefaluts.string(forKey: "count7")
        let dryCount = userdefaluts.string(forKey: "count8")
        let bathrooncount = userdefaluts.string(forKey: "count9")
        
        // textViewがnilがないか
        guard let forGuestMessage = textView.text else{
            print("nil")
            return
        }
        // userのプロフィール情報を持ってくる
        // タイムラインで使用するため
        var uName:String = ""
        var uImage:String = ""
        let currentUserProfile = db.collection("users").document(uid)
        currentUserProfile.getDocument { (snapshot, error) in
            if let error = error{
                print("\(error)")
            }
            guard let data = snapshot?.data() else {return}
            print(data)
            uName = data["userName"] as! String
            print(uName)
            uImage = data["userImage"] as! String
            print(uImage)
            
            // 投稿
            guard let imageData1 = self.userPickedImage1.image,
                let imageDate2 = self.userPickedImage2.image,
                let imageData3 = self.userPickedImage3.image,
                let imageData4 = self.userPickedImage4.image,
                let startDay = self.beginAcceptanceDate,
                let lastDay = self.finishAcceptanceDate,
                let imageName1 = self.fileName1,
                let imageName2 = self.fileName2,
                let imageName3 = self.fileName3,
                let imageName4 = self.fileName4
                else {return}
            
            //　投稿した日付
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let timestamp = formatter.string(from: Date())
            
            // randamID
            let randamID = UUID.init().uuidString
            
            // 辞書型で入れていく
            let toDataSave = ["categoryText":categoryText,
                              "buildingText":buildingText,
                              "selectedTag":selectedTag,
                              "numberOfGuestCount":numberOfGuestCount,
                              "numberOfGuestBedroomCount":numberOfGuestBedroomCount,
                              "numberOfGuestBedCount":numberOfGuestBedCount,
                              "yourAdress":yourAdress,
                              "yourKeyWord":yourKeyWord,
                              "necessaryCount":necessaryCount,
                              "wifiCount":wifiCount,
                              "kitchenCount":kitchenCount,
                              "heaterCount":heaterCount,
                              "airConCount":airConCount,
                              "tvCount":tvCount,
                              "laundryCount":laundryCount,
                              "dryCount":dryCount,
                              "bathrooncount":bathrooncount,
                              "forGuestMessage":forGuestMessage,
                              "createdAt":timestamp,
                              "uid":uid,
                              "startDay":startDay,
                              "lastDay":lastDay,
                              "userName":uName,
                              "userImage":uImage,
                              "postImage1":imageName1,
                              "postImage2":imageName2,
                              "postImage3":imageName3,
                              "postImage4":imageName4,
                              "ThisPostID":randamID
            ]
            
            // -----  userのポストにはIDを入れる　------------
            // 後で作る自分の投稿を確認できるタイムライン
            // realtime database
            let userPostUserID  = Database.database().reference().child("userPostID").child(uid)
            userPostUserID.setValue(randamID) { (error, result) in
                if error != nil {
                    // エラー
                    print("\(error?.localizedDescription)")
                }else{
                    // データが入った
                 print("dataが入りました")
              }
            }
            
            // userの投稿情報の新しいPOSTSコレクションを作る
            let userData = self.db.collection("userPosts").document(randamID)
            userData.setData(toDataSave as [String : Any]) { (error) in
                // errorなら
                if let error = error {
                    print("\(error)")
                } else {
                    print("Document add with Id\(String(describing: uid))")
                    // 配列として保持
                    let arrayImage = [imageData1,imageDate2,imageData3,imageData4]
                    // imageNameも配列の中に入れていく
                    let arrayImageName = [imageName1,imageName2,imageName3,imageName4]
                    
                    // uploadRefの中に入れる
                    let uploadRef1 = self.storage.reference().child("userPosts").child(uid).child(arrayImageName[0])
                    let uploadRef2 = self.storage.reference().child("userPosts").child(uid).child(arrayImageName[1])
                    let uploadRef3 = self.storage.reference().child("userPosts").child(uid).child(arrayImageName[2])
                    let uploadRef4 = self.storage.reference().child("userPosts").child(uid).child(arrayImageName[3])
                    
                    guard let imageData1 = arrayImage[0].jpegData(compressionQuality: 0.08) else {return}
                    guard let imageData2 = arrayImage[1].jpegData(compressionQuality: 0.08) else {return}
                    guard let imageData3 = arrayImage[2].jpegData(compressionQuality: 0.08) else {return}
                    guard let imageData4 = arrayImage[3].jpegData(compressionQuality: 0.08) else {return}
                    
                    //　ストレージを参照
                    let uploadMetaData = StorageMetadata()
                    // imageのタイプ
                    uploadMetaData.contentType = "image/jpeg"
                    uploadRef1.putData(imageData1, metadata: uploadMetaData) { (downloadMetaData, error) in
                        if let error = error {
                            print("画像をアップロードできません")
                            print("errorを見つけました\(error.localizedDescription)")
                            return
                        }
                        print("画像をアップロードしたよ")
                        print("\(String(describing: downloadMetaData))")
                        self.backToTimeLine()
                    }
                    
                    uploadRef2.putData(imageData2, metadata: uploadMetaData) { (downloadMetaData, error) in
                        if let error = error {
                            print("画像をアップロードできません")
                            print("errorを見つけました\(error.localizedDescription)")
                            return
                        }
                        print("画像をアップロードしたよ")
                        print("\(String(describing: downloadMetaData))")
                        self.backToTimeLine()
                    }
                    
                    uploadRef3.putData(imageData3, metadata: uploadMetaData) { (downloadMetaData, error) in
                        if let error = error {
                            print("画像をアップロードできません")
                            print("errorを見つけました\(error.localizedDescription)")
                            return
                        }
                        print("画像をアップロードしたよ")
                        print("\(String(describing: downloadMetaData))")
                        self.backToTimeLine()
                    }
                    
                    uploadRef4.putData(imageData4, metadata: uploadMetaData) { (downloadMetaData, error) in
                        if let error = error {
                            print("画像をアップロードできません")
                            print("errorを見つけました\(error.localizedDescription)")
                            return
                        }
                        print("画像をアップロードしたよ")
                        print("\(String(describing: downloadMetaData))")
                        self.stopLoadIndicator()
                        self.backToTimeLine()
                        self.userDefalutsDelated()
                    }
                }
            }
        }
    }
    
    // タイムラインへの遷移
    func backToTimeLine() {
    self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // インディケーター表示
    func showLodeIndicator() {
        indicatorBackgroundView = UIView(frame: self.view.bounds)
        indicatorBackgroundView.backgroundColor = .green
        indicatorBackgroundView.alpha = 0.2
        indicatorBackgroundView.tag = 1
        // インジケータと背景を接続
        self.view.addSubview(indicatorBackgroundView)
        indicatorBackgroundView?.addSubview(activityIndicatorView)
        view.isUserInteractionEnabled = false
        //        //起動
        activityIndicatorView.startAnimating()
    }
    // インジケータを非表示にする
    func stopLoadIndicator() {
        // インジケータを消すか判断
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        // 消えます
        activityIndicatorView.stopAnimating()
    }
    
    
    // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 情報を遷移するためにuserDefalutsは使っていたので
    // 投稿が終わったら消す
    func userDefalutsDelated() {
        
        userdefaluts.removeObject(forKey: "categoryText")
        userdefaluts.removeObject(forKey: "buildingText")
        userdefaluts.removeObject(forKey: "selectedTag")
        // post2
        userdefaluts.removeObject(forKey: "numberOfGuestCount")
        userdefaluts.removeObject(forKey: "numberOfGuestBedroomCount")
        userdefaluts.removeObject(forKey: "numberOfGuestBedCount")
        // post3
        userdefaluts.removeObject(forKey: "yourAdress")
        userdefaluts.removeObject(forKey: "yourKeyWord")
        // post4
        userdefaluts.removeObject(forKey: "count1")
        userdefaluts.removeObject(forKey: "count2")
        userdefaluts.removeObject(forKey: "count3")
        userdefaluts.removeObject(forKey: "count4")
        userdefaluts.removeObject(forKey: "count5")
        userdefaluts.removeObject(forKey: "count6")
        userdefaluts.removeObject(forKey: "count7")
        userdefaluts.removeObject(forKey: "count8")
        userdefaluts.removeObject(forKey: "count9")
        
    }
    
    
}




