//
//  PostInformationViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/03/09.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class PostInformationViewController: UIViewController {

    var thisPostID = ""
    var postUserID = ""
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("post情報をもっと詳しくお伝えします")
        print(thisPostID)
        print(postUserID)
        print(userID)
    }
    
  // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
