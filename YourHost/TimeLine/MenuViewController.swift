//
//  MenuViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import FacebookCore
import Firebase
import FacebookLogin


class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // セルがタップされると呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        switch indexPath.row  {
        case 0:
            dismiss(animated: true)
            print("homeに戻ります")
        case 1:
            performSegue(withIdentifier: "message", sender: nil)
        case 2:
            performSegue(withIdentifier: "Profile", sender: nil)
            
        case 3:
            performSegue(withIdentifier: "likes", sender: nil)
            
        case 4:
            
            // facebookログアウト
            let logoutManeger = LoginManager()
            logoutManeger.logOut()
                // ログアウト
            try! Auth.auth().signOut()
                // storyboardの指定
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let VC = storyboard.instantiateViewController(identifier: "Login")
                //  フルスクリーンに
                VC.modalPresentationStyle = .fullScreen
                // 遷移処理
                self.present(VC, animated: true, completion: nil)
                print("ログアウト")
            
        default:
            break
            
        }
    }
}
