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
    
    
    //
    var item:Int = 3
    
    
    // tableView
    @IBOutlet weak var hometableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // userdefaultsに保存
        UserDefaults.standard.set(userID, forKey: "userID")
        
        print(userID)
      
    }
    
   
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 後で消す
        return item
        
       }
       

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
               
        
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
