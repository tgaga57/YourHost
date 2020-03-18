//
//  HomeViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import NVActivityIndicatorView

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    // slideメニュー
    let transition = SlideTransition()
    // fireStore.firestorage
    let db = Firestore.firestore()
    // userid
    var userID:String = ""
    // 更新のぐるぐる
    let refreshControl = UIRefreshControl()
    // 投稿情報
    var items = [NSDictionary]()
    // tableView
    @IBOutlet weak var hometableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // userdefaultsに保存
        UserDefaults.standard.set(userID, forKey: "userID")
        print(userID)
        // refreshControlに文言を追加
        refreshControl.attributedTitle = NSAttributedString(string: "更新中")
        // アクションを指定
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // テーブルビューに追加
        hometableView.addSubview(refreshControl)
        // データの更新
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データの更新
        refresh()
        // navigationbarを消す
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 更新
    @objc func refresh() {
        // 初期化
        items = [NSDictionary]()
        // 情報を取得
        fetch()
        // tableViewをリロード
        hometableView.reloadData()
        // リフレッシュを止める
        refreshControl.endRefreshing()
    }
    
    //　情報を持ってくる
    func fetch(){
        db.collection("userPosts").order(by: "createdAt",descending: true).limit(to: 15).getDocuments{ (Snapshot, error) in
            var tempItems = [NSDictionary]()
            // for文で回し`item`に格納
            for item in Snapshot!.documents {
                // item内のデータをdictという変数に入れる
                let dict = item.data()
                // tempItemsに入れる
                tempItems.append(dict as NSDictionary)
            }
            // tempItemsをitemsに入れる
            self.items = tempItems
            
            self.hometableView.reloadData()
        }
    }
    
    // セルを表示したい数だけ返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // items(投稿の数だけ表示する)
        return items.count
    }
    
    // 各セルを返却してセルを生成します。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 行き先
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        // 選択不可にする
        cell.selectionStyle = .none
        
        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        
        // 投稿情報
        cell.set(dict: dict)
        
        // ViewControllerのポインタをセット
        cell.homeViewController = self
        
        return cell
    }
    
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }

    @IBAction func didTaped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        
        nextVC.modalPresentationStyle = .overCurrentContext
        
        nextVC.userId = userID
        
        nextVC.transitioningDelegate = self
        
        present(nextVC, animated: true)
    }
     
    // 遷移処理
    // goPostInfo
    func goPostInfomation(userPostID:String,postUserID:String,postUserName:String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let toPostInfoVC = storyboard.instantiateViewController(withIdentifier: "toPostInfo") as! PostInformationViewController
        toPostInfoVC.thisPostID = userPostID
        toPostInfoVC.postUserID = postUserID
        toPostInfoVC.postUname = postUserName
        toPostInfoVC.userID = userID
        toPostInfoVC.modalPresentationStyle = .fullScreen
        self.present(toPostInfoVC, animated: true, completion: nil)
    }
    
}


// スライドメニュー
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        print("メニューへ")
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        print("戻る")
        return transition
    }
    

}
