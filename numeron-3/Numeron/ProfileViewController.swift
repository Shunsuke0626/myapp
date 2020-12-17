//
//  ProfileViewController.swift
//  Numeron
//
//  Created by 中村俊輔 on 2018/08/05.
//  Copyright © 2018年 shunsuke. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate  {
    @IBOutlet var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults(呼び出し)
        let ud = UserDefaults.standard
        let username = ud.string(forKey: "username")
        if username == nil{
            usernameLabel.text = "名無しさん"
        }else{
            usernameLabel.text = username
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController?.tabBar.isHidden == true {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // ボタンを押下した時にアラートを表示するメソッド
    @IBAction func dispAlert(sender: UIButton) {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "名前の変更", message: "変更したい名前を入力してください", preferredStyle:  UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.delegate = self
        }
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            let textField = alert.textFields![0]
            let username = textField.text
            if username == nil{
                alert.dismiss(animated: true, completion: nil)
                return
            }else{
                //UserDeaults(保存)
                let ud = UserDefaults.standard
                ud.set(username!, forKey: "username")
                ud.synchronize()
                self.usernameLabel.text = username
            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
