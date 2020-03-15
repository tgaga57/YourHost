//
//  HomeTableViewCell.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/04.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class HomeTableViewCell: UITableViewCell{
    
    // 投稿者の画像
    @IBOutlet weak var postUserImage: UIImageView!
    //投稿者の名前
    @IBOutlet weak var postUserName: UILabel!
    // 掲載された宿の場所(地域名)
    @IBOutlet weak var postUserLocation: UILabel!
    // ゲスト宿泊開始可能日
    @IBOutlet weak var startDay: UILabel!
    // ゲストが宿泊最終日
    @IBOutlet weak var lastDay: UILabel!
    //スクロールview
    @IBOutlet weak var scrollView: UIScrollView!
    // pageContorol
    @IBOutlet weak var postPageControl: UIPageControl!
    // firebase
    let db = Firestore.firestore()
    // ストレージ使うときに必要
    let storage = Storage.storage()
    // PostImageの配列
    var postImages:[UIImage] = []
    // PostUserID
    var postUserID:String = ""
    // uiimageview
    @IBOutlet weak var postImageView1: UIImageView!
    @IBOutlet weak var postImageView2: UIImageView!
    @IBOutlet weak var postImageView3: UIImageView!
    @IBOutlet weak var postImageView4: UIImageView!
    // postID
    var postID:String = ""
    // 遷移処理に必要なもの
    var homeViewController:HomeViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postUserImage.layer.cornerRadius = 15.0
        // デリゲート
        self.scrollView.delegate = self
        // スクロールバーを消した
        scrollView.showsVerticalScrollIndicator = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(dict:NSDictionary) {
        // row番目のデータ
        postUserName.text = dict["userName"] as? String
        startDay.text = dict["startDay"] as? String
        lastDay.text = dict["lastDay"] as? String
        postUserLocation.text = dict["yourKeyWord"] as? String
        // postIDを持ってくる
        postID = dict["ThisPostID"] as! String
        // PostUsrIDを持ってくる
        postUserID = dict["uid"] as! String
        let profileImage = dict["userImage"] as! String
        //　NSData型に変更
        let dataProfImage = NSData(base64Encoded: profileImage , options: .ignoreUnknownCharacters)
        // UIImage型に
        let decodeProImage = UIImage(data: dataProfImage! as Data)
        // proImageに
        postUserImage.image = decodeProImage
        // 写真の大きさを見やすいように
        postUserImage.contentMode = .scaleAspectFill
        // 投稿写真に入れていく
        userPostImage(fileName1: dict["postImage1"] as! String, fileName2: dict["postImage2"] as! String, fileName3: dict["postImage3"] as! String, fileName4: dict["postImage4"] as! String,uid: (dict["uid"] as? String)!)
        // 初期化する
        // ここで初期化をしないと画像が読み込まれると無限に足されてします!
        postImages = []
    }

    // 引数でFileNameを入れてfor文で取ってくる
    // userpostの情報をstorageから取ってくる
    func userPostImage(fileName1:String,fileName2:String,fileName3:String,fileName4:String,uid:String) {
        // ストレージを参照
        let storageRef = storage.reference(withPath: "userPosts")
        // fileNameを入れてfirebase Storageから情報を持ってくる
        let downloadRef1 = storageRef.child(uid).child(fileName1)
        print(downloadRef1)
        let downloadRef2 = storageRef.child(uid).child(fileName2)
        print(downloadRef2)
        let downloadRef3 = storageRef.child(uid).child(fileName3)
        print(downloadRef3)
        let downloadRef4 = storageRef.child(uid).child(fileName4)
        print(downloadRef4)
        
        // データを取ってくる!!
        // fileName1
        downloadRef1.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("errorですよ\(error.localizedDescription)")
                return
            }
            // data
            guard let data = data else{
                return
            }
            print("dataがあります\(data)")
            let image = UIImage(data: data)
            // imageに反映
            self.postImageView1.image = image
            self.postImageView1.contentMode = .scaleAspectFill
        }
            // fileName2
            downloadRef2.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("errorですよ\(error.localizedDescription)")
                    return
                }
                // data
                guard let data = data else{
                    return
                }
                print("dataがあります\(data)")
                let image = UIImage(data: data)
                self.postImageView2.image = image
                self.postImageView2.contentMode = .scaleAspectFill
            }
            // fileName3
            downloadRef3.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("errorですよ\(error.localizedDescription)")
                    return
                }
                // data
                guard let data = data else{
                    return
                }
                print("dataがあります\(data)")
                let image = UIImage(data: data)
                self.postImageView3.image = image
                self.postImageView3.contentMode = .scaleAspectFill
            }
            // fileName4
            downloadRef4.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("errorですよ\(error.localizedDescription)")
                    return
                }
                // data
                guard let data = data else{
                    return
                }
                print("dataがあります\(data)")
                let image = UIImage(data: data)
                self.postImageView4.image = image
                self.postImageView4.contentMode = .scaleAspectFill
              }
         }
    
     // 投稿情報をもっと詳しく
    @IBAction func moreInfo(_ sender: Any) {
        print("遷移しますよおおおん")
        // 引数の中に現在ユーザーが見ているpostIDを入れる
        homeViewController?.goPostInfomation(userPostID: postID, postUserID: postUserID)
    }
}


extension HomeTableViewCell:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.postPageControl.currentPage = index
    }
}

