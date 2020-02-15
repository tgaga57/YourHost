//
//  HomeViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/05.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

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
    
    var userID:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Timeline")
        print(userID)
    }
    
    @IBAction func didTaped(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "Menu") else {return}
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
    
}

