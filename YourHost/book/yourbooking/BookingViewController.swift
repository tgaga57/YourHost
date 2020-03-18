//
//  BookingViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/18.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BookingViewController: UIViewController,IndicatorInfoProvider {
    
  
    // タブ名
    var itemInfoName: IndicatorInfo = "あなたの予約"
      
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return itemInfoName
        
    }
}
