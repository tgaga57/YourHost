//
//  PostViewController.swift
//  YourHost
//
//  Created by 志賀大河 on 2020/02/21.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import UIKit

class PostViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    // 選ばれたもの
    var selectedPriority : String?
    var selectedbuilding : String?
    //　選ばれるカテゴリーとタイプ
    var priorityTypes = ["住宅","マンション","アパート"]
    var buildingTypes = ["一軒家","ログハウス","古民家","長屋"]
    
    // user Id
    var userID:String = ""
    // setImage
    let image0:UIImage! = UIImage(named: "丸")
    let image1:UIImage! = UIImage(named: "チェック")
    // Pickerで何が選ばれたか
    var selectedCount = 0
    
    //　情報を受け渡すためのSelected count
    var selectedTag = 0
    // 家全体
    @IBOutlet weak var allHousingButton: UIButton!
    // 個室
    @IBOutlet weak var privateRoomButton: UIButton!
    // シェアルーム
    @IBOutlet weak var shareRoomButton: UIButton!
    
    // 住宅のカテゴリー情報
    @IBOutlet weak var categoryTextField: UITextField!
    // 建物のタイプ
    @IBOutlet weak var buildingTypeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        // picker
        createPickerView()
        
        print("ここにはきたよ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // アラート
        postconfirmationAlert()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // pickerのタグが1だったら
        if pickerView.tag == 1 {
            return priorityTypes.count
        }else{
            return buildingTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Pickerのタグが1だったら
        if pickerView.tag == 1 {
            return priorityTypes[row]
        } else{
            return buildingTypes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Pickerのtagが１だったら
        if pickerView.tag == 1 {
            selectedPriority = priorityTypes[row]
            categoryTextField.text = selectedPriority
            
        } else {
            selectedbuilding = buildingTypes[row]
            buildingTypeTextField.text = selectedbuilding
        }
        
    }
    
    func createPickerView() {
        let pickerView1 = UIPickerView()
        let pickerView2 = UIPickerView()
        // デリゲートの設定
        pickerView1.delegate = self
        pickerView2.delegate = self
        
        pickerView1.tag = 1
        pickerView2.tag = 2
        
        categoryTextField.inputView = pickerView1
        buildingTypeTextField.inputView = pickerView2
        dissMissPickerView()
    }
    
    // pickerで選択されたら終える
    func dissMissPickerView () {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // 完了ボタンの追加
        let doneButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryTextField.inputAccessoryView = toolBar
        buildingTypeTextField.inputAccessoryView = toolBar
    }
    
    // キーボードを消す
    @ objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    // 投稿していいかのアラートを出す
    func postconfirmationAlert() {
        let alert:UIAlertController = UIAlertController(title: "確認", message: "ホスティングを行うとタイムラインに掲載されますがよろしいですか？", preferredStyle: UIAlertController.Style.alert)
        
        let okAction:UIAlertAction = UIAlertAction(title: "Okay", style: .default) { (alert) in
            print("Ok")
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        // アラートにadd
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // buttonTag
    enum buttonTag:Int {
        case action1 = 1
        case action2 = 2
        case action3 = 3
    }
    
    // ボタンがタップされた
    @IBAction func didSelectedTappedButton(_ sender: Any) {
        // タグを判別
        if let button = sender as? UIButton {
            if let tag = buttonTag(rawValue: button.tag) {
                // それぞれのメソッドを呼ぶ
                switch tag {
                case .action1:
                    buttanAction1()
                case .action2:
                    buttonAction2()
                case .action3:
                    buttonAction3()
                default:
                    break
                }
                // ボタンがどれが選ばれているか確認
                print(button.tag)
                selectedTag = button.tag
            }
        }
    }
    
    // allHousingButoonが選択されたら
    func buttanAction1(){
        allHousingButton.setImage(image1, for: .normal)
        privateRoomButton.setImage(image0, for: .normal)
        shareRoomButton.setImage(image0, for: .normal)
    }
    // privateButtonが選択されたら
    func buttonAction2(){
        privateRoomButton.setImage(image1, for: .normal)
        allHousingButton.setImage(image0, for: .normal)
        shareRoomButton.setImage(image0, for: .normal)
    }
    // shareRoomButtonが選択されたら
    func buttonAction3(){
        shareRoomButton.setImage(image1, for: .normal)
        allHousingButton.setImage(image0, for: .normal)
        privateRoomButton.setImage(image0, for: .normal)
    }
    
    //　戻る
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        if selectedTag == 0 {
            print("ゼロです")
            return
        } else if categoryTextField.text == "" || buildingTypeTextField.text == "" {
            print("カテゴリーが選ばれていません")
            return
        } else {
        
        guard let categoryText = categoryTextField.text,let buildingText = buildingTypeTextField.text else {
            return
        }
            
        // userDefalutsで保存
            UserDefaults.standard.set(categoryText, forKey: "categoryText")
            UserDefaults.standard.set(buildingText, forKey: "buildingText")
            UserDefaults.standard.set(selectedTag, forKey: "selectedTag")
        
            
        print(selectedTag)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "Post2") as! Post2ViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
            

        }
    }
}
