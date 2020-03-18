//
//  BookerViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/18.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BookerViewController: UIViewController,IndicatorInfoProvider{
  
    // タブの名前
    var itemInfoName:IndicatorInfo = "投稿への予約者"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfoName
    }

}
