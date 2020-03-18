//
//  YourbookViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/18.
//  Copyright © 2020 Taiga Shiga. All rights reserved.


import UIKit
import XLPagerTabStrip

class YourbookViewController: ButtonBarPagerTabStripViewController {

    // userID
   var userID = ""
    
    override func viewDidLoad() {

        settings.style.selectedBarBackgroundColor = .lightGray
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let booker = UIStoryboard(name: "booker", bundle: nil).instantiateViewController(identifier: "booker")
        
        let yourBooking = UIStoryboard(name: "yourBooking", bundle: nil).instantiateViewController(identifier: "yourBooking")
        
        let childViewControllers:[UIViewController] = [yourBooking,booker]
               
        return childViewControllers
    }

}
