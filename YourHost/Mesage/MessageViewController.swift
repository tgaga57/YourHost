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
    
    // textView
    
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("遷移されてきましたよ")
        print(message.thePostID)
        print(message.postUserID)
        print(message.yourUID)

        tableView.dataSource = self
        tableView.delegate = self
    
        // 丸く
        sendButton.layer.cornerRadius = 10
        
        configureNotification()
        
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
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルを生成 メッセージ情報など
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // 行き先
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! MessageTableViewCell
        return cell
       }
    
    // 高さを決める
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // 他のびviewを触ったら閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    //送信ボタンが押された時
    @IBAction func sendAction(_ sender: Any) {
        
    }
    
   
    // データを取ってくる
    func fetchData(){
     
    }

}
