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

// スライド
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
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
        print("Timeline")
        
        print(userID)
    }
    
    @IBAction func didTaped(_ sender: Any) {
//        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "Menu") else {return}
//
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
        
        
//        menuViewController.modalPresentationStyle = .overCurrentContext
        
        nextVC.modalPresentationStyle = .overCurrentContext
        
        nextVC.userId = userID
//      menuViewController.transitioningDelegate = self
        
        nextVC.transitioningDelegate = self
        
        present(nextVC, animated: true)
        
    }
}

