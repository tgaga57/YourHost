//
//  Post6ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/28.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class Post6ViewController: UIViewController {
    
    // title label
    @IBOutlet weak var titleLabel: UILabel!
    
    var beginAcceptanceDate = ""
    var finishAcceptanceDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "掲載する写真と\nゲストへのメッセージを\n投稿しよう"
        
        print(beginAcceptanceDate)
        print(finishAcceptanceDate)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
