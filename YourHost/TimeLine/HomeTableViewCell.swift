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
    
    // 投稿者の写真
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
    
    // firebase
    let db = Firestore.firestore()
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postUserImage.layer.cornerRadius = 15.0
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
    }
    
    
    
    
}
