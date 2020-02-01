//
//  NewSettingViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/01.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class NewSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

}
