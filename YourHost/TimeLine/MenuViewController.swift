//
//  MenuViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UITableViewController {
    
    let transition = SlideTransition()
    
    // DBのログインしたuserの情報が入ってくる from home
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userId)
        
        var user = UserDefaults.standard.object(forKey: "userID")!
        
        print(user)
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
            // 確認
            postconfirmationAlert()
        case 4:
            performSegue(withIdentifier: "Booking", sender: nil)
            print("予約へ")
        case 5:
            // ログアウト
            try! Auth.auth().signOut()
//            // storyboardの指定
//            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let VC = storyboard.instantiateViewController(identifier: "Login")
//            //  フルスクリーンに
//            VC.modalPresentationStyle = .fullScreen
//            // 遷移処理
//            self.present(VC, animated: true, completion: nil)
            
            self.presentingViewController?.presentingViewController?
                .dismiss(animated: true, completion: nil)
            print("ログアウト")
            
        default:
            break
        }
    }
    
    // 情報を受け渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Profile"{
            let profileVC = segue.destination as! ProfViewController
            // ログインしているuserId情報
            profileVC.uID = userId
        }
    }
    
    // 投稿していいかのアラートを出す
       func postconfirmationAlert() {
           let alert:UIAlertController = UIAlertController(title: "確認", message: "ホスティングを行うとタイムラインに掲載されますがよろしいですか？", preferredStyle: UIAlertController.Style.alert)
           
           let okAction:UIAlertAction = UIAlertAction(title: "Okay", style: .default) { (alert) in
             print("Ok")
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
            nextVC.userID = self.userId
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
            print("ホスティングへ")
              
           }
           
           let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
           }
           // アラートにadd
           alert.addAction(okAction)
           alert.addAction(cancelAction)
           
           present(alert, animated: true, completion: nil)
       }
    
    // このviewを消す
    // 消さないと遷移先の画面から
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.isHidden = true
    }
}
