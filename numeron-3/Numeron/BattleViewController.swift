//
//  BattleViewController.swift
//  Numeron
//
//  Created by 中村俊輔 on 2018/08/05.
//  Copyright © 2018年 shunsuke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BattleViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    // データベースへの参照を定義
    var ref: DatabaseReference!
    //ルーム番号定義
    var roomNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 128/255, blue: 168/255, alpha: 1.0) // ボタン背景色設定
        button.backgroundColor = rgba                                               // 背景色
        button.layer.borderWidth = 0.5                                              // 枠線の幅
        button.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        button.layer.cornerRadius = 10.0                                             // 角丸のサイズ
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        // DatabaseReferenceのインスタンス化
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        //UserDefaults(呼び出し)
        let ud = UserDefaults.standard
        let username = ud.string(forKey: "username")
        if username == nil{
            usernameLabel.text = "名無しさん"
        }else{
            usernameLabel.text = username
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func inputRoomNumber(){ 
        let alert = UIAlertController(title: "部屋の番号", message: "3桁の数字を入力して下さい", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = UIKeyboardType.numberPad // 数字のみの入力
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.ref.child("rooms").setValue(alert.textFields![0].text!)
            self.roomNumber = Int(alert.textFields![0].text!)!
            self.performSegue(withIdentifier: "toChatRoom", sender: nil)
            // OKの時のアクション
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得
        let viewController = segue.destination as! ViewController
        viewController.roomNumber = String(roomNumber)
        
    }
}
