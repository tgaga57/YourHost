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
    
    let transition = SlideTransition()
    
    var ref: DocumentReference!
    // インスタンス
    let db = Firestore.firestore()
    // DBのログインしたuserの情報が入ってくる from home
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // セルがタップされると呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
    // indexの番号で遷移する先を指定する
        switch indexPath.row  {
        case 0:
            dismiss(animated: true)
            print("homeに戻ります")
        case 1:
            performSegue(withIdentifier: "message", sender: nil)
            print("メッセージへ")
        case 2:
            performSegue(withIdentifier: "Profile", sender: nil)
            print("プロフィールへ")
        case 3:
            performSegue(withIdentifier: "Post", sender: nil)
            print("ホスティングへ")
        case 4:
            performSegue(withIdentifier: "Booking", sender: nil)
            print("予約へ")
        case 5:
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
    // 情報を受け渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Profile"{
            let profVC = segue.destination as! ProfViewController
            // ログインしているuserId情報
            profVC.uID = userId
        }
        else if segue.identifier == "Post"{
            let postVC = segue.destination as! PostViewController
            // ログインしているuserId情報
            postVC.userID = userId
        }
    }
    
    // このviewを消す
    // 消さないと遷移先の画面から
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.isHidden = true
    }
}
