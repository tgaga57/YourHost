//
//  MessageRoomViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/13.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase

class MessageRoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    // メッセージから来たのかそれとも投稿情報画面から来たのかを見極めるカウント
    var whrereIsFromCount:Int = 0
    
    var messageRoomArray = [Message]()
    
    let message = Message()
    
    let db = Firestore.firestore()
    
    let reldb = Database.database()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("あなたはどこからきたの\(whrereIsFromCount)")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageRoomCell", bundle: nil), forCellReuseIdentifier: "MessageRoomCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        // 情報をとってくる
        fetchMessageOponentData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // メッセージしている人の数を返してあげる
        return messageRoomArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageRoomCell",for: indexPath) as! MessageRoomCell
        //        // Name
        //        cell.messageUserName.text = messageRoomArray[indexPath.row].senderName
        //        // 角を丸くした
        //        cell.messageTextView.layer.cornerRadius = 10.0
        //        // userImageをとってくる64String型のため変換が必要
        //        let uImage64String = messageRoomArray[indexPath.row].userProfImage
        //        //　NSData型に変更
        //        let dataProfImage = NSData(base64Encoded: uImage64String , options: .ignoreUnknownCharacters)
        //        // UIImage型に
        //        let decodeProImage = UIImage(data: dataProfImage! as Data)
        //
        //        cell.messageUserImage.layer.cornerRadius = 15.0
        //        cell.messageUserImage.contentMode = .scaleAspectFill
        //        // userImageを入れる
        //        cell.messageUserImage.image = decodeProImage
        //
        //        cell.messageTextView.text = messageRoomArray[indexPath.row].message
        
        // row番目postuserIDを取ってくる
        // 角を丸くした
        cell.messageTextView.layer.cornerRadius = 12.5
        cell.imageView?.layer.cornerRadius = 25
        cell.messageUserImage.contentMode = .scaleAspectFill
        
        let messageRef  = db.collection("users").document(messageRoomArray[indexPath.row].postUserID)
        messageRef.getDocument { (Snapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            guard let data = Snapshot?.data() else{return}
            let opppnentUserImage = data["userImage"] as! String
            let opponentUserName = data["userName"] as! String
            
            // userImageをとってくる64String型のため変換が必要
            let uImage64String = opppnentUserImage
            //　NSData型に変更
            let dataProfImage = NSData(base64Encoded: uImage64String , options: .ignoreUnknownCharacters)
            // UIImage型に
            let decodeProImage = UIImage(data: dataProfImage! as Data)
            // 名前
            cell.messageUserName.text = opponentUserName
            // 写真イメージ
            cell.messageUserImage.image = decodeProImage
            // cellのメッセージを反映
            let chatRef = self.reldb.reference().child("chats").child(self.messageRoomArray[indexPath.row].chatID)
            chatRef.observe(.childAdded) { (snapshot) in
                let chatData = snapshot.value as AnyObject
                let message = chatData.value(forKey: "message") as! String
                // メッセージ
                cell.messageTextView.text = message
            }
        }
        
    
        // セルに反映
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目が選択されました")
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "message") as! MessageViewController
        // セルのrow番目をとってくる
         // postID
        nextVC.message.thePostID = messageRoomArray[indexPath.row].thePostID
        // PostuserID
        nextVC.message.postUserID = messageRoomArray[indexPath.row].postUserID
        // your userID
        nextVC.message.yourUID = message.yourUID
        
        nextVC.modalPresentationStyle = .fullScreen
        // ここで遷移
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // messageしているデータのところにいく
    func fetchMessageOponentData() {
        print("データを持ってくるよ")
        // yourchatDBを入れていく
        let fethchDataRef = reldb.reference().child("yourChatDB").child(message.yourUID)
        fethchDataRef.observe(.childAdded) { (snapShot) in
            let snapData = snapShot.value as AnyObject
            let opponentUserID = snapData.value(forKey: "opponentID") as! String
            let thisPostID = snapData.value(forKey: "thisPostId") as! String
            let chatID = snapData.value(forKey: "chatID") as! String
            print("おおおおおおおおおおおおおおおおおおおおおおおおおおおお\(opponentUserID)")
            print(thisPostID)
            print(chatID)
            // messgeメソッドを呼び出す
            let message = Message()
            // userID
            message.postUserID = opponentUserID
            // chatID
            message.chatID =  chatID
            // postID
            message.thePostID = thisPostID
            
            self.messageRoomArray.append(message)
            self.tableView.reloadData()
            //            // ユーザープロフィール写真をとってくる
            //            self.db.collection("users").document(opponentUserID).getDocument { (SnapShot, error) in
            //                if let error = error {
            //                    print("\(error.localizedDescription)")
            //                }
            //                guard let data = SnapShot?.data()  else {return}
            //                let opponentUserImage = data["userImage"] as! String
            //                let opponentUserName = data["userName"] as! String
            //
            //                self.reldb.reference().child("chats").child(chatID).observe(.childAdded) { (DataSnapshot) in
            //                    let data = DataSnapshot.value as AnyObject
            //                    let textMessage = data.value(forKey: "message") as! String
            //                    // messgeメソッドを呼び出す
            //                    let message = Message()
            //                    // ここで入れていく
            //                    // メッセージ
            //                    message.message = textMessage
            //                    // 名前
            //                    message.senderName = opponentUserName
            //                    // プロフィール
            //                    message.userProfImage = opponentUserImage
            //                    // userID
            //                    message.postUserID = opponentUserID
            //                    // chatID
            //                    message.chatID =  chatID
            //                    // postID
            //                    message.thePostID = thisPostID
            //
            //                    self.messageRoomArray.append(message)
            //                    self.tableView.reloadData()
            //                    print("ここも呼ばれたよ")
            //                }
            //            }
        }
        
        
    }
    
    
    // 戻る
    @IBAction func back(_ sender: Any) {
        // タイムラインから直接きた場合
        if whrereIsFromCount == 1 {
            //タイムラインにバック
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            print("タイムラインに戻ります")
            //投稿情報から遷移してきた場合
        } else {
            // タイムラインに戻る
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            print("タイムラインに戻ります")
        }
    }
    
}
