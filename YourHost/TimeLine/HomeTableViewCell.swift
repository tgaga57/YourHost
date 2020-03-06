//
//  HomeTableViewCell.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/04.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postUserImage.layer.cornerRadius = 15.0
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
