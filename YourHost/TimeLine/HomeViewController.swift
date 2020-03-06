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
    
    var item:Int = 3
    // 投稿情報
    var items = [NSDictionary]()
    // 投稿された写真
    var postImages:[String] = []
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
        db.collection("userPosts").order(by: "createdAt",descending: true).limit(to: 15).getDocuments { (Snapshot, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        // 選択不可にする
        cell.selectionStyle = .none
        
        // itemsの中からindexpathのrow番目を取得
        let dict = items[(indexPath as NSIndexPath).row]
        
        cell.set(dict: dict)
        
        return cell
    }
    
    
    
    // UIImageViewを生成
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image)
        imageView.image = image
        return imageView
    }
    
    
    @IBAction func didTaped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        
        nextVC.modalPresentationStyle = .overCurrentContext
        
        nextVC.userId = userID
        
        nextVC.transitioningDelegate = self
        
        present(nextVC, animated: true)
        
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
