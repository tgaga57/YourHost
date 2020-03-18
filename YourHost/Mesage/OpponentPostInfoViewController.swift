//
//  OpponentPostInfoViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/17.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class OpponentPostInfoViewController: UIViewController {
    
    // storage用
    var ref: DocumentReference!
    // インスタンス化
    let db = Firestore.firestore()
    // メッセージメソッド
    let message = Message()
    // スクロール横だけにするため
    var posY: CGFloat!
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
    
    // scrollview
    @IBOutlet weak var postScrollview: UIScrollView!
    
    //アメニティ
    @IBOutlet weak var necessitiesButton: UIButton!
    @IBOutlet weak var wifiButton: UIButton!
    @IBOutlet weak var kitchenButton: UIButton!
    @IBOutlet weak var heatingButton: UIButton!
    @IBOutlet weak var AirConButron: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var laundryButton: UIButton!
    @IBOutlet weak var dryButton: UIButton!
    @IBOutlet weak var bathroomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 情報がきているのか確認など
        print(message.postUserID)
        print(message.thePostID)
        
        // データを持ってくる
        getPostData(PostID: message.thePostID, postUserID: message.postUserID)
        // image写真を丸くする
        postUserImage.layer.cornerRadius = 15.0
        
        self.postScrollview.delegate = self
        // 縦の動き禁止
        postScrollview.showsVerticalScrollIndicator = false
        
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
            
            self.messageToGuest.text = data["forGuestMessage"] as? String
            let locationAdress = data["yourAdress"] as! String
            // 住所を反映
            self.mapkitReflection(adress: locationAdress)
            // 必需品
            let necceities = data["necessaryCount"] as! String
            // wifi
            let wifi = data["wifiCount"] as! String
            let kitchen = data["kitchenCount"] as! String
            let heater = data["heaterCount"] as! String
            let aircon = data["airConCount"] as! String
            let tv = data["tvCount"] as! String
            let laundry = data["laundryCount"] as! String
            let dry = data["dryCount"] as! String
            let barhroom = data["bathrooncount"] as! String
            
            self.amenities(amenitie: necceities, wifi: wifi, kitchen: kitchen, heater: heater, aircon: aircon, TV: tv, washingMachine: laundry, dryMachine: dry, bath: barhroom)
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
        let downloadRef1 = ref.child(message.postUserID).child(post1)
        print(downloadRef1)
        let downloadRef2 = ref.child(message.postUserID).child(post2)
        print(downloadRef2)
        let downloadRef3 = ref.child(message.postUserID).child(post3)
        print(downloadRef3)
        let downloadRef4 = ref.child(message.postUserID).child(post4)
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
    
    // mapkitに反映
    func mapkitReflection(adress:String) {
        // mapviewは変更予約が確定してからみれるため、ここでは使用を不可能にする!
        location.isZoomEnabled = false
        location.isScrollEnabled = false
        //中心座標
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        //表示範囲
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01 )
        //中心座標と表示範囲をマップに登録する。
        let region = MKCoordinateRegion(center: center, span: span)
        location.setRegion(region, animated: true)
        
        
        let myGeocoder:CLGeocoder = CLGeocoder()
        // 住所をアドレスの中に入れる
        let searchYourAdress = adress
        
        UserDefaults.standard.set(searchYourAdress, forKey: "searchYourAdress")
        
        myGeocoder.geocodeAddressString(searchYourAdress) { (placeMarks, error) in
            
            if error == nil {
                for placemark in placeMarks!{
                    let location:CLLocation = placemark.location!
                    
                    //中心
                    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    
                    //表示範囲
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    
                    //中心座標と表示範囲をマップに登録する。
                    let region = MKCoordinateRegion(center: center, span: span)
                    self.location.setRegion(region, animated:true)
                    
                    //地図にピンを立てる。
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                    self.location.addAnnotation(annotation)
                }
            }
        }
    }
    
    // アメニティ
    func amenities(amenitie:String,wifi:String,kitchen:String,heater:String,aircon:String,TV:String,washingMachine:String,dryMachine:String,bath:String) {
        //必需品
        if amenitie == "0" {
            necessitiesButton.isEnabled = false
            necessitiesButton.backgroundColor = .clear
        }
        // wifi
        if wifi == "0" {
            wifiButton.isEnabled = false
            wifiButton.backgroundColor = .clear
        }
        // kitchen
        if kitchen == "0" {
            kitchenButton.isEnabled = false
            kitchenButton.backgroundColor = .clear
        }
        // 暖房
        if heater == "0" {
            heatingButton.isEnabled = false
            heatingButton.backgroundColor = .clear
            
        }
        // aircon
        if aircon == "0" {
            AirConButron.isEnabled = false
            AirConButron.backgroundColor = .clear
        }
        // 洗濯機
        if washingMachine == "0" {
            laundryButton.isEnabled = false
            laundryButton.backgroundColor = .clear
        }
        // 乾燥機
        if dryMachine == "0" {
            dryButton.isEnabled = false
            dryButton.backgroundColor = .clear
        }
        //  シャワーお風呂
        if kitchen == "0" {
            kitchenButton.isEnabled = false
            kitchenButton.backgroundColor = .clear
        }
        
    }
    
    //back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OpponentPostInfoViewController:UIScrollViewDelegate{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
           self.pageControl.currentPage = index
           self.postScrollview.contentOffset.y = posY
       }
       
       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           posY = self.postScrollview.contentOffset.y
       }
    
}
