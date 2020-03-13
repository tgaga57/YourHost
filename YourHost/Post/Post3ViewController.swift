//
//  Post3ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/22.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import MapKit

class Post3ViewController: UIViewController,UITextFieldDelegate{
    
    // スクロールview
    let scrollView = UIScrollView()
    // 
    var scrollFormer:CGFloat! = nil
    
    var textfield = UITextField()
    
    var allY:CGFloat  = 0.0
    
    var userID = ""
    // 住所
    @IBOutlet weak var yourStreetAddressTextFiled: UITextField!
    // マップ
    @IBOutlet weak var mapView: MKMapView!
    // キーワード
    @IBOutlet weak var yourCityName: UITextField!
    // スクロールview
    @IBOutlet weak var scroll: UIScrollView!
    
    //選択されたtextFieldは何か
    var selectedTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yourStreetAddressTextFiled.delegate = self
        yourCityName.delegate = self
        
        //中心座標
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        //表示範囲
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01 )
        
        //中心座標と表示範囲をマップに登録する。
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        // nortificationを発動
        configureNotification()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // nortificationを発動
        configureNotification()
    }
    
    // nortificationメソッド化
    func configureNotification () {
        // キーボード出てくるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(Post3ViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // キーボード閉じるときに発動
        NotificationCenter.default.addObserver(self, selector: #selector(Post3ViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    // キーボードが呼び出される時
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardwillshow発動")
        
    }
    // キーボードを消す時
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
    
    
    // reternが押された時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            
            let myGeocoder:CLGeocoder = CLGeocoder()
            // 住所
            let searchYourAdress = textField.text!
            
            UserDefaults.standard.set(searchYourAdress, forKey: "searchYourAdress")
            
            myGeocoder.geocodeAddressString(searchYourAdress) { (placeMarks, error) in
                
                if error == nil {
                    for placemark in placeMarks!{
                        let location:CLLocation = placemark.location!
                        
                        //中心
                        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                        
                        //表示範囲
                        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        
                        //中心座標と表示範囲をマップに登録する。
                        let region = MKCoordinateRegion(center: center, span: span)
                        self.mapView.setRegion(region, animated:true)
                        
                        //地図にピンを立てる。
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                        self.mapView.addAnnotation(annotation)
                    }
                } else {
                    // 検索できなかったら
                    self.yourStreetAddressTextFiled.text = "検索できませんでした"
                }
            }
            
        }
        
        yourStreetAddressTextFiled.resignFirstResponder()
        yourCityName.resignFirstResponder()
        return true

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // next
    @IBAction func next(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post4") as! Post4ViewController
        
        guard let yourAdress = yourStreetAddressTextFiled.text, let yourKeyWord = yourCityName.text else {return}
        
        if yourAdress == "" || yourKeyWord == "" {
            return
        } else {
            // userDefaultsに保存
            UserDefaults.standard.set(yourAdress, forKey: "yourAdress")
            UserDefaults.standard.set(yourKeyWord, forKey: "yourKeyWord")
            // フルスクリーンに
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.userID = userID
            // 遷移
            self.present(nextVC, animated: true, completion: nil)
        }
    }
    
    
    // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


