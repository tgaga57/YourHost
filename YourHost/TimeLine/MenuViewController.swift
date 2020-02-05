//
//  MenuViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case home
    case message
    case profile
    case likes
}

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        print("dissmissing: \(menuType)")
    }
    
}
