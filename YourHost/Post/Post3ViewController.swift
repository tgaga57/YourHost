//
//  Post3ViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/22.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit
import MapKit

class Post3ViewController: UIViewController,UITextFieldDelegate {

    // 住所
    @IBOutlet weak var yourStreetAddressTextFiled: UITextField!
    // マップ
    @IBOutlet weak var mapView: MKMapView!
    /// 情報を前の画面から受け取る　post1 post2
    // ゲストの数
    var totalCapasityGuest:Int = 0
    // ゲストのベッドルーム数
    var totalCapasityGuestBedRoom:Int = 0
    // ゲストのベッド数
    var totalCapasityGuestBed:Int = 0
    // カテゴリー
    var categoriesType:String = ""
    //　建物の種類
    var buildingType:String = ""
    // ゲストが使える施設
    var guestCanUse:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Post3")
        print(totalCapasityGuest)
        print(totalCapasityGuestBedRoom)
        print(totalCapasityGuestBed)
        print(categoriesType)
        print(buildingType)
        print(guestCanUse)
        
        yourStreetAddressTextFiled.delegate = self
        
        //中心座標
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        //表示範囲
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01 )
        
        //中心座標と表示範囲をマップに登録する。
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
                self.yourStreetAddressTextFiled.text = "検索できませんでした"
            }

        }
        yourStreetAddressTextFiled.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        // 検索できなきなかったとする
        self.yourStreetAddressTextFiled.text = "検索できませんでした"
    }
    
    // 住所を入力する前に
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 何か入力されていたら消す
        yourStreetAddressTextFiled.text = ""
        
    }
    
    
    // next
    @IBAction func next(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post4") as! Post4ViewController
        // フルスクリーンに
        nextVC.modalPresentationStyle = .fullScreen
        // 遷移
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
   // back
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
