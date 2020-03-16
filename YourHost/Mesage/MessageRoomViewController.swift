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
        
//        db.collection("users").document(message.yourUID).getDocument { (snapShot, error) in
//            if let error = error {
//                print("\(error)")
//            }
//            guard let data = snapShot?.value(forKey: AnyObject)
//        }
//        // Name
//        cell.messageUserName.text = messageRoomArray[indexPath.row].senderName
//               // userImageをとってくる64String型のため変換が必要
//               let uImage64String = messageRoomArray[indexPath.row].userProfImage
//               //　NSData型に変更
//               let dataProfImage = NSData(base64Encoded: uImage64String , options: .ignoreUnknownCharacters)
//               // UIImage型に
//               let decodeProImage = UIImage(data: dataProfImage! as Data)
//
//               cell.messageUserImage.layer.cornerRadius = 10.0
//               cell.messageUserImage.contentMode = .scaleAspectFill
//               // userImageを入れる
//               cell.messageUserImage.image = decodeProImage
            return cell
        
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目が選択されました")
        
        performSegue(withIdentifier: "\(indexPath.row)", sender: nil)
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
        
        let fethchDataRef = reldb.reference().child("yourChatDB").child(message.yourUID)
        fethchDataRef.observe(.childAdded) { (snapShot) in
            let snapData = snapShot.value as AnyObject
            
            let opponentID = snapData.value(forKey: "opponentID")
            let thisPostID = snapData.value(forKey: "thisPostId")
            let chatID = snapData.value(forKey: "chatID")
            
            let message = Message()
            message.postUserID = opponentID as! String
            message.chatID =  chatID as! String
            message.thePostID = thisPostID as! String
            
            
            
            
            self.messageRoomArray.append(message)
            self.tableView.reloadData()
            
           print("ここも呼ばれたよ")
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
