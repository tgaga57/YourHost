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
    // collectionview
    @IBOutlet weak var slideCollectionView: UICollectionView!
    // pagescroll
    @IBOutlet weak var pageControl: UIPageControl!
    // userID
    var uID = ""
    // firebase
    let db = Firestore.firestore()
    // ストレージ使うときに必要
    let storage = Storage.storage()
    // PostImageの配列
    var postImages:[UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postUserImage.layer.cornerRadius = 15.0
        // 写真の数だけ
        pageControl.currentPage = postImages.count
        print(postImages.count)
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
        userPostImage(fileName1: dict["postImage1"] as! String, fileName2: dict["postImage2"] as! String, fileName3: dict["postImage3"] as! String, fileName4: dict["postImage4"] as! String)
    }
    
    
    // 引数でFileNameを入れてfor文で取ってくる
    // userpostの情報をstorageから取ってくる
    func userPostImage(fileName1:String,fileName2:String,fileName3:String,fileName4:String) {
        // ストレージを参照
        let storageRef = storage.reference()
        let arrayFilename = [fileName1,fileName2,fileName3,fileName4]
        // fileNameを入れてfirebase Storageから情報を持ってくる
        for fileName in arrayFilename {
            let downLoadRef = storageRef.child("userPosts").child("\(uID)").child(fileName)
            downLoadRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("errorですよ\(error.localizedDescription)")
                    return
                }
                if let data = data {
                    // postImageに入れていく
                    // どっちを使う?
                    self.postImages = [UIImage(data: data)!]
                    self.postImages.append(UIImage(data: data)!)
                    print(self.postImages)
                }
            }
        }
    }
}


extension HomeTableViewCell:UICollectionViewDataSource,UICollectionViewDelegate {
    // ひとつのセクションにの中に表示するセルの数
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          // userpostの数だけ返す　四つとなる
           return postImages.count
       }
       // セルの要素に表示する内容
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPostCell", for: indexPath)

           cell.backgroundColor = .blue
           return cell
       }
    
}
