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

// ここから
class HomeViewController: UIViewController{
    
    let transition = SlideTransition()
    
    let db = Firestore.firestore()
    
    var text = ""
    
    var userID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // userdefaultsに保存
        UserDefaults.standard.set(userID, forKey: "userID")
        
        print(userID)
    }
    
    @IBAction func didTaped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        
        nextVC.modalPresentationStyle = .overCurrentContext
        
        nextVC.userId = userID
        
        nextVC.transitioningDelegate = self
        
        present(nextVC, animated: true)
        
    }
    

}

