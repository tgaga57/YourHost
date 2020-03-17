//
//  MessageViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/13.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
    
    // 送信
    @IBOutlet weak var sendButton: UIButton!
    // tableview
    @IBOutlet weak var tableView: UITableView!
    // 下のview
    @IBOutlet weak var underView: UIView!
    // ここにメッセージを入力
    @IBOutlet weak var messageTextView: UITextView!
    
    // notificication center
    let nd = NotificationCenter.default
    //　スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    // メッセージが入るクラス
    var chatArray = [Message]()
    // 投稿情報から受け渡された情報
    var message = Message()
    // firestore
    let db = Firestore.firestore()
    
    @IBOutlet weak var bookButton: UIButton!
    
    var whrereIsfForm:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("chat")
        print(message.thePostID)
        print(message.postUserID)
        print(message.yourUID)
        print(whrereIsfForm)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // 丸く
        sendButton.layer.cornerRadius = 10
        // 
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 44
        
        // キーボードの開閉に伴うメソッド
        configureNotification()
        
        // データを持ってくる
        fetchData()
        
        tableView.allowsSelection = false
    }
    
    
    func configureNotification() {
        // キーボード出てくるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // キーボード閉じるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //　キーボードが出る時
    @objc func keyboardWillShow(_ notification: NSNotification){
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        underView.frame.origin.y = screenSize.height - keyboardHeight - underView.frame.height
        
    }
    
    // キーボード消える時
    @objc func keyboardWillHide(_ notification:NSNotification) {
        
        underView.frame.origin.y = screenSize.height - underView.frame.height
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    
    // セルの数 チャット数の数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルを生成メッセージ情報などをcellに反映
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 行き先
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! MessageTableViewCell
        // message
        cell.messageTextView.text = chatArray[indexPath.row].message
        // senderName
        cell.senderNameLabel.text = chatArray[indexPath.row].senderName
        // 角を丸くする
        cell.messageTextView.layer.cornerRadius = 10.0
        // userImageをとってくる64String型のため変換が必要
        let uImage64String = chatArray[indexPath.row].userProfImage
        //　NSData型に変更
        let dataProfImage = NSData(base64Encoded: uImage64String , options: .ignoreUnknownCharacters)
        // UIImage型に
        let decodeProImage = UIImage(data: dataProfImage! as Data)
        
        cell.senderImage.layer.cornerRadius = 20.0
        cell.senderImage.contentMode = .scaleAspectFill
        // userImageを入れる
        cell.senderImage.image = decodeProImage
        
        // 自分と相手でテキストの色を変える
        if cell.senderImage.image == decodeProImage {
            cell.messageTextView.backgroundColor = .init(red: 0, green: 55, blue: 33, alpha: 0.9)
        } else {
            cell.messageTextView.backgroundColor = .init(red: 3, green: 45, blue: 32, alpha: 0.9)
        }
        
        return cell
    }
    
    // 高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // 他のびviewを触ったら閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //　送信ボタンが押された時
    //　メッセージを作成書き込み
    @IBAction func sendAction(_ sender: Any) {
        let relDB = Database.database()
                        // ここでチャットIDを作成する///////////////////////////////
                        // 送信者のところにメッセージろルームを作成
                        let chat = [self.message.postUserID,self.message.yourUID].sorted()
                        let chatID = chat[0] + chat[1]
                        // チャットIDに格納
                        self.message.chatID = chatID
                        // 送信者のメッセージデータを作成
                        let senderData = ["opponentID":self.message.postUserID,"thisPostId":self.message.thePostID,"chatID":self.message.chatID]
                        let senderChatDB = relDB.reference().child("yourChatDB").child(self.message.yourUID).child(chatID)
                        senderChatDB.setValue(senderData) { (error, result) in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                print("エラ-")
                            } else if result == senderChatDB{
                                print("データが存在するよ")
                            }else {
                                print("作成成功")
                            }
                        }
                        // メッセージを受けっとった相手にもここのメッセージを送る
                        let reciverData = ["opponentID":self.message.yourUID,"thisPostId":self.message.thePostID,"chatID":self.message.chatID]
                        //　受け取り側にメッセージロームを作成
                        let reciceverChatDB = relDB.reference().child("yourChatDB").child(self.message.postUserID).child(chatID)
                        reciceverChatDB.setValue(reciverData) { (error, result) in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                print("error")
                            }else {
                                print("作成成功")
                            }
                        }
            // メッセージ
            let chatDB = relDB.reference().child("chats").child(message.chatID)
            // userのプロフィールイメージをとってくる
            let currentUserProfile = db.collection("users").document(message.yourUID)
            currentUserProfile.getDocument { (snapshot, error) in
                if let error = error{
                    print("\(error)")
                }
                guard let data = snapshot?.data() else {return}
                print(data)
                // userの名前
                let senderName = data["userName"] as! String
                // 送信者の写真
                let uImage = data["userImage"] as! String
                // メッセージ内容など送信者の情報を入れていく
                let messageInfo = ["message":self.messageTextView.text!,"senderName":senderName,"userImage":uImage,"senderID":self.message.yourUID]
                chatDB.childByAutoId().setValue(messageInfo) { (error, resultDB) in
                    if error != nil{
                        print("error\(error?.localizedDescription)")
                    }else {
                        self.messageTextView.isEditable = true
                        self.sendButton.isEnabled = true
                        self.messageTextView.text = ""
                        self.messageTextView.endEditing(true)
                        print("送信完了")
                    }
                }
            }
        }
        
        // データを取ってくる //更新
        func fetchData(){
            // ここでチャットIDを作成する///////////////////////////////
            // 送信者のところにメッセージろルームを作成
            let chat = [message.postUserID,message.yourUID].sorted()
            let chatID = chat[0] + chat[1]
            // チャットIDに格納
            message.chatID = chatID
            
            let fethchDataRef = Database.database().reference().child("chats").child(message.chatID)
            // データを取ってくる
            fethchDataRef.observe(.childAdded) { (snapShot) in
                // 新しい更新があったときだけ取得したい取得したい
                let snapData = snapShot.value as AnyObject
                let sendMessage = snapData.value(forKey: "message")
                let userImage = snapData.value(forKey: "userImage")
                let senderName = snapData.value(forKey: "senderName")
                
                // 　Message.Swiftの中に入れていく
                let message = Message()
                message.message = sendMessage as! String
                message.userProfImage = userImage as! String
                message.senderName = senderName as! String
                // この後にアペンドしていく
                self.chatArray.append(message)
                self.tableView.reloadData()
            }
        }
        
        // 情報を受け渡す
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "messageRoom" {
                let messageRooomVC = segue.destination as! MessageRoomViewController
                // userIDを送る
                messageRooomVC.message.yourUID = message.yourUID
            }
        }
        
       
       
    // 投稿情報を確認
    @IBAction func toinfo(_ sender: Any) {
        
        let opponentPostInfo = self.storyboard?.instantiateViewController(withIdentifier: "OpponentPostInfo") as! OpponentPostInfoViewController
        opponentPostInfo.message.postUserID = message.postUserID
        opponentPostInfo.message.thePostID = message.thePostID
        
        opponentPostInfo.modalPresentationStyle = .fullScreen
        present(opponentPostInfo, animated: true, completion: nil)
    }
    
    
    
        // 戻る
        @IBAction func Back(_ sender: Any) {
            // もしメッセージをしにきたのが投稿情報の方からだったら
            if whrereIsfForm == 1 {
                self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
                // メッセージの方からきたら
            }else{
                dismiss(animated: true, completion: nil)
            }
        }
        
}
