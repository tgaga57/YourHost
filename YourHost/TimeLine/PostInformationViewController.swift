//
//  PostInformationViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/09.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseFirestore
import Firebase

class PostInformationViewController: UIViewController {
    // postID
    var thisPostID = ""
    // 投稿者ID
    var postUserID = ""
    // 自分自身のID
    var userID = ""
    // database用
    var ref: DocumentReference!
    // インスタンス化
    let db = Firestore.firestore()
    
    //投稿写真
    @IBOutlet weak var postImage1: UIImageView!
    @IBOutlet weak var postImage2: UIImageView!
    @IBOutlet weak var postImage3: UIImageView!
    @IBOutlet weak var postImage4: UIImageView!
    
    // 投稿者のprofile Image
    @IBOutlet weak var postUserImage: UIImageView!
    // pagecontrol
    @IBOutlet weak var pageControl: UIPageControl!
    // 投稿者の名前
    @IBOutlet weak var postUserName: UILabel!
    // 場所
    @IBOutlet weak var locationName: UILabel!
    // 地図
    @IBOutlet weak var location: MKMapView!
    // 受け入れ開始日
    @IBOutlet weak var startDay: UILabel!
    // 受け入れ終了日
    @IBOutlet weak var lasdDay: UILabel!
    // カテゴリー
    @IBOutlet weak var houseCategories: UILabel!
    // 住宅タイプ
    @IBOutlet weak var typeOfHouse: UILabel!
    // ゲストが使える部屋
    @IBOutlet weak var guestCanUseRoom: UILabel!
    // ゲストの定員数
    @IBOutlet weak var numberOfGuest: UILabel!
    // ゲストの寝室数
    @IBOutlet weak var forGuestBedRoom: UILabel!
    // ゲスト用のベッド数
    @IBOutlet weak var forGuestBed: UILabel!
    // ゲストへのメッセージ
    @IBOutlet weak var messageToGuest: UITextView!
    // ホストへのメッセージ
    @IBOutlet weak var messageToHost: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("post情報をもっと詳しくお伝えします")
        print(thisPostID)
        print(postUserID)
        print(userID)
        // ボタンを丸く
        messageToHost.layer.cornerRadius = 15.0
        // データを持ってくるr
        getPostData(PostID: thisPostID, postUserID: postUserID)
        // image写真を丸くする
        postUserImage.layer.cornerRadius = 15.0
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func getPostData(PostID:String,postUserID:String){
        db.collection("userPosts").document(PostID).getDocument { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = snap?.data() else{return}
            // ドキュメントのデータを取得していく
            let profImage = data["userImage"] as! String
            // NSData型に変換
            let dataProfileimage = NSData(base64Encoded: profImage, options: .ignoreUnknownCharacters)
            // UIImage型に変換
            let decodePostImage = UIImage(data: dataProfileimage! as Data)
            // イメージを入れていく
            self.postUserImage.image = decodePostImage
            self.postUserImage.contentMode = .scaleAspectFill
            // いろんなのをラベルに反映
            self.postUserName.text = data["userName"] as? String
            self.locationName.text = data["yourKeyWord"] as? String
            self.startDay.text = data["startDay"] as? String
            self.lasdDay.text = data["lastDay"] as? String
            // カテゴリー
            let category = data["categoryText"] as! String
            let type = data["buildingText"] as! String
            self.categoreis(category: category, type: type)
            
            let guestAvailbleRoom = data["selectedTag"] as! String
            self.availableRoomType(roomNumber: guestAvailbleRoom)
            
            let numberOfBed = data["numberOfGuestBedCount"] as! String
            let numberOfBedroom = data["numberOfGuestBedroomCount"] as! String
            let numberOfGuest = data["numberOfGuestBedCount"] as! String
            
            self.prepareForGuest(guestBed: numberOfBed, guestBedRoom: numberOfBedroom, guestNumber: numberOfGuest)
            
            let postImage1 = data["postImage1"] as! String
            let postImage2 = data["postImage2"] as! String
            let postImage3 = data["postImage3"] as! String
            let postImage4 = data["postImage4"] as! String
            
            self.userPostImageGetData(post1: postImage1, post2: postImage2, post3: postImage3, post4: postImage4)
            
        }
    }
    
    
    // ゲストのベッド数とかのところ
    func prepareForGuest(guestBed:String,guestBedRoom:String,guestNumber:String){
        // ここに入れる
        numberOfGuest.text = guestNumber + "人まで"
        forGuestBedRoom.text = guestBedRoom + "部屋"
        forGuestBed.text = guestBed + "個"
    }
    
    // カテゴリー
    func categoreis(category:String,type:String) {
        houseCategories.text = category
        typeOfHouse.text = type
    }
    
    // 部屋のカテゴリー
    func availableRoomType(roomNumber:String) {
        switch roomNumber {
        case "1":
            guestCanUseRoom.text = "住宅全体"
        case "2":
            guestCanUseRoom.text = "個室"
        case "3":
            guestCanUseRoom.text = "シェアルーム"
        default:
            return
        }
    }
    
    // postImageをとってくる
    func userPostImageGetData(post1:String,post2:String,post3:String,post4:String) {
        // storage
        let ref = Storage.storage().reference(withPath: "userPosts")
        // fileNameを入れてfirebase Storageから情報を持ってくる
        let downloadRef1 = ref.child(postUserID).child(post1)
        print(downloadRef1)
        let downloadRef2 = ref.child(postUserID).child(post2)
        print(downloadRef2)
        let downloadRef3 = ref.child(postUserID).child(post3)
        print(downloadRef3)
        let downloadRef4 = ref.child(postUserID).child(post4)
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
            self.postImage1.image = image
            self.postImage1.contentMode = .scaleAspectFill
        }
        
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
            // imageに反映
            self.postImage2.image = image
            self.postImage2.contentMode = .scaleAspectFill
        }
        
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
            // imageに反映
            self.postImage3.image = image
            self.postImage3.contentMode = .scaleAspectFill
        }
        
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
            // imageに反映
            self.postImage4.image = image
            self.postImage4.contentMode = .scaleAspectFill
        }
        
    }
    
    
    // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
